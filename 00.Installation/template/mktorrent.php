<?php
/*
MkTorrent WebUI
Copyright (C) 2009 RustyBadger

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

The author of this software can be contacted at rustybadger at users.sourceforge.net.
*/

// Config
$root = "/home/REPLACEUSERNAME"; // Set this to the directory you want to expose (e.g. /home/rtorrent)
$mktorrent = "/usr/bin/mktorrent"; // This should be (for security reasons) the full path to mktorrent. (It can be found by running `which mktorrent` if you're unsure.)

function normalise($path) { // This normalises a path to its simplest form, and also prevents jailbreaking.
	$normalised = array();
	foreach (explode("/", $path) as $p) {
		if ($p == "..") {array_pop($normalised);}
		else if ($p == ".") {}
		else if ($p) {array_push($normalised, $p);}
	}
	array_unshift($normalised, ""); // This means the path always starts with /
	return implode("/", $normalised);
}

$_POST['input'] = normalise($_POST['input']);
$_POST['output'] = normalise($_POST['output']);

if ($_POST['inputnav'] != "" && isset($_POST['input']) && is_dir($root . $_POST['input'])) {$_POST['inputpath'] = $_POST['input'];}
if ($_POST['outputnav'] != "" && isset($_POST['output']) && is_dir($root . $_POST['output'])) {$_POST['outputpath'] = $_POST['output'];}

$command = $mktorrent . " ";
if (is_array($_POST['announce'])) {foreach ($_POST['announce'] as $a) {if ($a != "") {$command .= "-a " . escapeshellarg($a) . " ";}}} else {$_POST['announce'] = array();}
if ($_POST['public'] != "") {if ($_POST['public'] == "false") {$command .= "-p ";}} else {$_POST['public'] = "true";}
if ($_POST['piecelength'] != "") {$command .= "-l " . escapeshellarg($_POST['piecelength']) . " ";}
if (is_array($_POST['webseeds'])) {foreach ($_POST['webseeds'] as $w) {if ($w != "") {$command .= "-w " . escapeshellarg($w) . " ";}}} else {$_POST['webseeds'] = array();}
if ($_POST['name'] != "") {$command .= "-n " . escapeshellarg($_POST['name']) . " ";}
if ($_POST['comment'] != "") {$command .= "-c " . escapeshellarg($_POST['comment']) . " ";}
if ($_POST['creation'] != "") {if ($_POST['creation'] == "false") {$command .= "-d ";}} else {$_POST['creation'] = "true";}
if ($_POST['verbose'] != "") {if ($_POST['verbose'] == "false") {$command .= "-v ";}} else {$_POST['verbose'] = "true";}
if ($_POST['outputfile'] != "") {$command .= "-o " . escapeshellarg($root . $_POST['outputpath'] . "/" . $_POST['outputfile']) . " ";} else {$_POST['outputfile'] = ".torrent";}
if ($_POST['input'] != "") {$command .= escapeshellarg($root . $_POST['input']);}

if ($_POST['report'] == "") {$_POST['report'] = "false";}
if ($_POST['advanced'] == "") {$_POST['advanced'] = "false";}

if ($_POST['inputnav'] == "" && $_POST['outputnav'] == "") {exec($command, $returnstr, $return);}
else {$command = ""; $returnstr = array(); $return = -1;}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>MkTorrent WebUI</title>
<script type="text/javascript">
function showhide(id, input) {
	if (document.getElementById(id).style.display == "none") {
		document.getElementById(id).style.display = "";
		document.getElementById(input).value = "true";
	} else {
		document.getElementById(id).style.display = "none";
		document.getElementById(input).value = "false";
	}
}
function label(id, check) {document.getElementById(id).focus(); if (check) {document.getElementById(id).checked = true;}}<?php // This is because a label outside of a td doesn't work, and inside only the text is clickable. ?>
function insertRow(table, name) {
	var row = table.insertRow(table.rows.length - 1);
	var cell = document.createElement("td"); row.appendChild(cell);
	var input = document.createElement("input");
		input.type = "text";
		input.name = name;
		input.onblur =  function() {if (this.value == "") {deleteRow(table, row.rowIndex);}};
	cell.appendChild(input);
		input.focus();
}
function deleteRow(table, index) {
	table.deleteRow(index);
}
</script>
<style type="text/css">
h2 {text-decoration: underline;}
table, select, input {width: 100%;}
input[type=radio] {width: auto;}
</style>
</head>
<body>
<form action="<?php echo $_SERVER['REQUEST_URI']; ?>" method="post">
<h2><a href="javascript: showhide('reportid', 'report');">Report</a><input type="hidden" name="report" id="report" value="<?php echo $_POST['report']; ?>" /></h2>
<p><?php switch ($return) {case -1: echo ""; break; case 0: echo "MkTorrent Ran Sucessfully."; break; default: echo "MkTorrent Reported An Error."; break;} ?></p>
<pre id="reportid"<?php echo ($_POST['report'] == "true" ? "" : " style=\"display: none;\""); ?>>
<?php
if ($command != "") {echo "# " . htmlspecialchars(str_replace(array($root, $mktorrent), array("", "mktorrent "), $command)) . "\n";}
echo htmlspecialchars(str_replace($root, "", implode("\n", $returnstr)));
?>
</pre>
<h2>Options</h2>
<table>
<tr><td onclick="label('announce');">Tracker Groups:</td><td>
<table id="announcetable">
<?php
foreach ($_POST['announce'] as $i) {if ($i != "") {echo "<tr><td><input type=\"text\" name=\"announce[]\" value=\"" . htmlspecialchars($i) . "\" onblur=\"if (this.value == '') {deleteRow(document.getElementById('announcetable'), this.parentNode.parentNode.rowIndex);}\" /></td></tr>\n";}}
?>
<tr><td><input type="text" name="announce[]" id="announce" onfocus="insertRow(document.getElementById('announcetable'), 'announce[]');" /></td></tr>
</table>
</td></tr>
<tr><td rowspan="2">Public Torrent:</td><td onclick="label('publictrue', true);"><input type="radio" name="public" id="publictrue" value="true"<?php echo ($_POST['public'] == "true" ? " checked=\"checked\"" : ""); ?> /> Public</td></tr>
<tr><td onclick="label('publicfalse', true);"><input type="radio" name="public" id="publicfalse" value="false"<?php echo ($_POST['public'] == "false" ? " checked=\"checked\"" : ""); ?> /> Private</td></tr>
</table>
<table>
<tr><td style="width: 50%;" onclick="label('input');">Input File/Directory:</td><td colspan="2" style="width: 50%;" onclick="label('outputfile');">Output Torrent:</td></tr>
<tr><td rowspan="2">
<input type="hidden" name="inputpath" value="<?php echo htmlspecialchars($_POST['inputpath']); ?>" />
<input type="hidden" name="inputnav" />
<select name="input" id="input" size="16" ondblclick="this.form.inputnav.value = 'true'; this.form.submit();" onkeypress="if (event.keyCode == 13) {this.form.inputnav.value = 'true'; this.form.submit();};">
<?php
if ($dir = dir($root . $_POST['inputpath'])) {
	$nodes = array();
	while ($node = $dir->read()) {array_push($nodes, $node);} $dir->close();
	natcasesort($nodes);
	foreach ($nodes as $node) {echo "<option value=\"" . htmlspecialchars($_POST['inputpath'] . "/" . $node) . "\"" . ($_POST['input'] == $_POST['inputpath'] . "/" . $node ? " selected=\"selected\"" : "") . ">" . htmlspecialchars($node) . "</option>\n";}
} else {echo "<option value=\"" . htmlspecialchars($_POST['inputpath'] . "/.") . "\">.</option>\n<option value=\"" . htmlspecialchars($_POST['inputpath'] . "/..") . "\">..</option>\n<option value=\"" . htmlspecialchars($_POST['inputpath'] . "/") . "\">Failed to Open Directory</option>\n";}
?>
</select>
</td><td><input type="text" name="outputfile" id="outputfile" value="<?php echo htmlspecialchars($_POST['outputfile']); ?>" /></td><td>in</td></tr>
<tr><td colspan="2">
<input type="hidden" name="outputpath" value="<?php echo htmlspecialchars($_POST['outputpath']); ?>" />
<input type="hidden" name="outputnav" />
<select name="output" size="14" ondblclick="this.form.outputnav.value = 'true'; this.form.submit();" onkeypress="if (event.keyCode == 13) {this.form.outputnav.value = 'true'; this.form.submit();};" onblur="this.options[this.selectedIndex].selected = false;">
<?php
if ($dir = dir($root . $_POST['outputpath'])) {
	$nodes = array();
	while ($node = $dir->read()) {array_push($nodes, $node);}
	$dir->close();
	natcasesort($nodes);
	foreach ($nodes as $node) {echo "<option value=\"" . htmlspecialchars($_POST['outputpath'] . "/" . $node) . "\">" . htmlspecialchars($node) . "</option>\n";}
} else {echo "<option value=\"" . htmlspecialchars($_POST['outputpath'] . "/.") . "\">.</option>\n<option value=\"" . htmlspecialchars($_POST['outputpath'] . "/..") . "\">..</option>\n<option value=\"" . htmlspecialchars($_POST['outputpath'] . "/") . "\">Failed to Open Directory</option>\n";}
?>
</select>
</td></tr>
</table>
<h2><a href="javascript: showhide('advancedid', 'advanced');">Advanced Options</a><input type="hidden" name="advanced" id="advanced" value="<?php echo $_POST['advanced']; ?>" /></h2>
<table id="advancedid"<?php echo ($_POST['advanced'] == "true" ? "" : " style=\"display: none;\""); ?>>
<tr><td onclick="label('piecelength');">Piece Length (in 2^n bytes):</td><td><input type="text" name="piecelength" id="piecelength" value="<?php echo htmlspecialchars($_POST['piecelength']); ?>" /></td></tr>
<tr><td onclick="label('webseeds');">Web Seeds URLs:</td><td>
<table id="webseedstable">
<?php
foreach ($_POST['webseeds'] as $i) {if ($i != "") {echo "<tr><td><input type=\"text\" name=\"webseeds[]\" value=\"" . htmlspecialchars($i) . "\" onblur=\"if (this.value == '') {deleteRow(document.getElementById('webseedstable'), this.parentNode.parentNode.rowIndex);}\" /></td></tr>\n";}}
?>
<tr><td><input type="text" name="webseeds[]" id="webseeds" onfocus="insertRow(document.getElementById('webseedstable'), 'webseeds[]');" /></td></tr>
</table>
</td></tr>
<tr><td onclick="label('name');">Torrent Name:</td><td><input type="text" name="name" id="name" value="<?php echo htmlspecialchars($_POST['name']); ?>" /></td></tr>
<tr><td onclick="label('comment');">Comment:</td><td><input type="text" name="comment" id="comment" value="<?php echo htmlspecialchars($_POST['comment']); ?>" /></td></tr>
<tr><td rowspan="2">Write Creation Date:</td><td onclick="label('creationtrue', true);"><input type="radio" name="creation" id="creationtrue" value="true"<?php echo ($_POST['creation'] == "true" ? " checked=\"checked\"" : ""); ?> /> Yes</td></tr>
<tr><td onclick="label('creationfalse', true);"><input type="radio" name="creation" id="creationfalse" value="false"<?php echo ($_POST['creation'] == "false" ? " checked=\"checked\"" : ""); ?> /> No</td></tr>
<tr><td rowspan="2">Be Verbose:</td><td onclick="label('verbosetrue', true);"><input type="radio" name="verbose" id="verbosetrue" value="true"<?php echo ($_POST['verbose'] == "true" ? " checked=\"checked\"" : ""); ?> /> Yes</td></tr>
<tr><td onclick="label('verbosefalse', true);"><input type="radio" name="verbose" id="verbosefalse" value="false"<?php echo ($_POST['verbose'] == "false" ? " checked=\"checked\"" : ""); ?> /> No</td></tr>
</table>
<div><button type="submit">MkTorrent!</button></div>
</form>
<p><a href="http://sourceforge.net/projects/mktorrentwebui" rel="external" onclick="window.open(this.href); return false;"><img src="http://sflogo.sourceforge.net/sflogo.php?group_id=260083&amp;type=10" width="80" height="15" alt="Check out our SourceForge project page" /></a></p>
</body>
</html>
