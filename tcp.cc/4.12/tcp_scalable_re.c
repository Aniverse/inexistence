/* Scalable-Reactive (Scalable-RE) congestion control */

#include <linux/module.h>
#include <net/tcp.h>

#define INIT_CWND_SCALE 8  /* scaling factor to initialize cwnd */
#define MIN_CWND 22

/* Scalable-RE congestion control block */
struct scalable {
	u32 prior_cwnd,  /* prior cwnd upon entering loss recovery */
	prev_ca_state:3,  /* CA state on previous ACK */
	max_acked:1,  /* maximum number of ACK received */
	peak_delivered:1,  /* peak threshould of available cwnd in cycle before we filled pipe */
	conceal_loss:1;  /* perform concealment of packet losses? */ 
};

static const u32 scalable_init_cwnd = (1 << INIT_CWND_SCALE);
static const u32 scalable_cwnd_min_target = MIN_CWND;

/* Slow-start up toward maximum available cwnd (if bw estimate is growing, or packet loss
 * has drawn us down below target), or snap down to target if we're above it.
 */
static void tcp_scalable_re_set_cwnd(
	struct sock *sk, u32 acked)
{
	struct tcp_sock *tp = tcp_sk(sk);
	struct scalable *ca = inet_csk_ca(sk);
	u32 cwnd, max_snd_cwnd_thresh = (0xffffffff >> 7);

	cwnd = max_t(u32, ca->peak_delivered, scalable_init_cwnd);

	if (ca->conceal_loss)
		return;

	/* use the maximum number of ACKs we observed: */
	ca->max_acked = max_t(u32, ca->max_acked, acked);

	/* slow-start up toward the bottleneck bandwidth: */ 
	if (inet_csk(sk)->icsk_ca_state == TCP_CA_Open)
		cwnd = min(max_snd_cwnd_thresh, (cwnd * 17 >> 4) + acked);
	else
		cwnd = ca->peak_delivered;  /* not to exceed peak threshould when congestion can occur: */
	cwnd = max(cwnd, scalable_cwnd_min_target);

	/* Reduce delayed ACKs by rounding up cwnd to the next even number. */
	cwnd = (cwnd + 1) & ~1U;

	tp->snd_cwnd = cwnd;
}


/* Try to conceal packet losses and keep pipe filled: */
static void tcp_scalable_re_loss_concealment(
	struct sock *sk, const struct rate_sample *rs, u32 acked)
{
	struct tcp_sock *tp = tcp_sk(sk);
	struct scalable *ca = inet_csk_ca(sk);
	u8 prev_state = ca->prev_ca_state, state = inet_csk(sk)->icsk_ca_state;
	u32 cwnd = tp->snd_cwnd;

	ca->max_acked = max_t(u32, ca->max_acked, acked);

	/* update peak threshould then do the loss concealment: */

	ca->peak_delivered = max_t(u32, ca->peak_delivered, rs->delivered);

	if (state == TCP_CA_Recovery && prev_state != TCP_CA_Recovery) {
		cwnd = max_t(u32, cwnd - rs->losses + ca->max_acked, ca->peak_delivered);  /* deduct the number of lost packets */
		ca->peak_delivered = max_t(u32, ca->peak_delivered - rs->losses,
			(ca->peak_delivered * 7 >> 3));  /* lower peak threshould estimate (0.875x) when pipe is probably full */
		ca->max_acked >>= 1;
	}
	else
		cwnd = max(cwnd, ca->prior_cwnd);  /* restore cwnd after exiting loss recovery */

	cwnd = max(cwnd, scalable_cwnd_min_target);

	ca->prev_ca_state = state;
	tp->snd_cwnd = cwnd;
	ca->conceal_loss = 0;
}

static void tcp_scalable_re_main(struct sock *sk, const struct rate_sample *rs)
{
	struct scalable *ca = inet_csk_ca(sk);

	ca->peak_delivered = max_t(u32, ca->peak_delivered, 
		rs->delivered);  /* save maximum peak threshould observed first */
	tcp_scalable_re_set_cwnd(sk, rs->acked_sacked);
	tcp_scalable_re_loss_concealment(sk, rs, rs->acked_sacked);
}

static void tcp_scalable_re_set_state(struct sock *sk, u8 new_state)
{
	struct scalable *ca = inet_csk_ca(sk);

	if (new_state == TCP_CA_Loss) {
		ca->prev_ca_state = TCP_CA_Loss;
		ca->conceal_loss = 1;
	}
}

static void tcp_scalable_re_init(struct sock *sk)
{
	struct scalable *ca = inet_csk_ca(sk);

	ca->max_acked = 0;
	ca->peak_delivered = 0;
	ca->conceal_loss = 0;
	ca->prev_ca_state = TCP_CA_Open;
}

static u32 tcp_scalable_re_ssthresh(struct sock *sk)
{
	const struct tcp_sock *tp = tcp_sk(sk);
	struct scalable *ca = inet_csk_ca(sk);

	ca->prior_cwnd = tp->snd_cwnd;
	return TCP_INFINITE_SSTHRESH;
}

static u32 tcp_scalable_re_undo_cwnd(struct sock *sk)
{
	return tcp_sk(sk)->snd_cwnd;
}

static struct tcp_congestion_ops tcp_scalable_re_cong_ops __read_mostly = {
	.flags		= TCP_CONG_NON_RESTRICTED,
	.name		= "scalable-re",
	.owner		= THIS_MODULE,
	.init		= tcp_scalable_re_init,
	.cong_control	= tcp_scalable_re_main,
	.undo_cwnd	= tcp_scalable_re_undo_cwnd,
	.ssthresh	= tcp_scalable_re_ssthresh,
	.set_state	= tcp_scalable_re_set_state,
};

static int __init tcp_scalable_re_register(void)
{
	BUILD_BUG_ON(sizeof(struct scalable) > ICSK_CA_PRIV_SIZE);
	return tcp_register_congestion_control(&tcp_scalable_re_cong_ops);
}

static void __exit tcp_scalable_re_unregister(void)
{
	tcp_unregister_congestion_control(&tcp_scalable_re_cong_ops);
}

module_init(tcp_scalable_re_register);
module_exit(tcp_scalable_re_unregister);

MODULE_AUTHOR("Neal Cardwell <ncardwell@google.com>");
MODULE_AUTHOR("Yuchung Cheng <ycheng@google.com>");
MODULE_AUTHOR("John Heffner");
MODULE_LICENSE("Dual BSD/GPL");
MODULE_DESCRIPTION("TCP Scalable-RE (Scalable-Reactive)");