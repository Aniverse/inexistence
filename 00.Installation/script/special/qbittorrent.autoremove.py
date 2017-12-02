# -*- coding: UTF-8 -*-
from qbittorrent import Client
import time
import requests
from time import sleep
import ConfigParser
import os
import sys
import re

class my_qBittorrent(object):
    def __init__(self,config):
        self.config = config
        username = self.config.get('global','webui_username')
        password = self.config.get('global','webui_password')
        webui_url = self.config.get('global','webui_url')
        self.torrentHash = []
        self.torrentData = []
        self.client = Client(webui_url)
        self.client.login(username, password)
        self.getTorrentInfo()
        self.getTorrentSeedTime()
    
    def getTorrentInfo(self):
        self.torrents = self.client.torrents(filter = 'completed')
        for torrent in self.torrents:
            self.torrentHash.append(torrent['hash'])
        return
        
    def getTorrentSeedTime(self):
        for torrentHash in self.torrentHash:
            torrentDict = {'hash':torrentHash,'info':self.client.get_torrent(torrentHash)}
            self.torrentData.append(torrentDict)
        return
    
    def deleteTorrentPerm(self,torrentHash):
        self.client.delete_permanently(torrentHash)
        return
    
    def getSingleTorrentInfo(self,torrentHash):
        torrentDict = {'hash':torrentHash,'info':self.client.get_torrent(torrentHash)}
        return torrentDict
    
    def seedTimeFilter(self,torrentHash,seedTime=1):
        seedTimeConv = seedTime*3600
        torrentInfo = self.getSingleTorrentInfo(torrentHash)
        seedingTime = torrentInfo['info']['seeding_time']
        if seedingTime > seedTimeConv:
            return True
        return False
    
    def trackerFilter(self,torrentHash,trackers = None):
        #add the tracker exception
		if trackers:
			pattern = re.compile(r',+\s*')
			trackers = pattern.split(trackers)
			for tracker in trackers:
				rawInfo = self.client.get_torrent_trackers(torrentHash)
				torrentTracker = rawInfo[0]['url']
				if tracker in torrentTracker:
					return True
		return False
    
    def addedTimeFilter(self,torrentHash,addedTime = 1):
        #default day
        torrentInfo = self.getSingleTorrentInfo(torrentHash)
        addedTimeConv = addedTime*24*3600
        timeElapsed = torrentInfo['info']['time_elapsed']
        if timeElapsed > addedTimeConv:
            return True
        return False
    
    def integratedFilterAndExecute(self,torrentHash,tacker = None, lowerLimit = None):
        seed_time = self.config.getint('filter','seeding_time')
        if not lowerLimit:
            if not self.trackerFilter(torrentHash, tracker = tacker):
                if self.seedTimeFilter(torrentHash, seedTime = seed_time):
                    self.deleteTorrentPerm(torrentHash)
                    
        else:
            if not self.trackerFilter(torrentHash, tracker = tacker):
                if self.seedTimeFilter(torrentHash, seedTime = seed_time) and self.filterUploadSpeed(torrentHash, lowerLimit = lowerLimit):
                    self.deleteTorrentPerm(torrentHash)
    
    def Traversal(self):
        tracker = self.config.get('filter','exception_tracker')
        lowerLimit = self.config.get('filter','upload_speed')
        for torrentHash in self.torrentHash:
            self.integratedFilterAndExecute(torrentHash,tracker,lowerLimit = lowerLimit)

    def getUploadSpeed(self,torrentHash):
        torrentInfo = self.getSingleTorrentInfo(torrentHash)
        torrentUpSpeed = torrentInfo['up_speed']
        return torrentUpSpeed

    def filterUploadSpeed(self,torrentHash,lowerLimit = None):
        torrentUpSpeed = self.getUploadSpeed(torrentHash)
        if lowerLimit:
            if torrentUpSpeed < lowerLimit:
                return True
            else:
                return False
        return False
    

def parserConfig(pathToConfig):
    config_path = os.path.expanduser(pathToConfig)
    config = ConfigParser.SafeConfigParser()
    
    if os.path.isfile(config_path):
        config.read(config_path)
    else:
        configDir = os.path.dirname(config_path)
        if not os.path.isdir(configDir):
            os.makedirs(configDir)
        
        config.add_section('global')
        config.set('global', 'webui_url', '')
        config.set('global', 'webui_username', '')
        config.set('global','webui_password','')
        
        config.add_section('filter')
        config.set('filter', 'seeding_time', '')
        config.set('filter','exception_tracker','')
        config.set('filter','upload_speed')
        
        with open(config_path,'w') as f:
            config.write(f)
            
        print('Please edit the configuration file: %s' % pathToConfig)
        sys.exit(2)
        
    return config

def main():
    config = parserConfig('~/.qBautoremove/config')
    while 1:
        try:
            newclient = my_qBittorrent(config)
            newclient.Traversal()
        except requests.exceptions.ConnectionError:
                continue
        time.sleep(300)
    
if __name__ == '__main__': main()

    
            
        
        
