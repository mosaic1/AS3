/**
 * @author			Ahmed Nuaman (http://www.ahmednuaman.com)
 * @langversion		3
 * 
 * This work is licenced under the Creative Commons Attribution-Share Alike 2.0 UK: England & Wales License. 
 * To view a copy of this licence, visit http://creativecommons.org/licenses/by-sa/2.0/uk/ or send a letter 
 * to Creative Commons, 171 Second Street, Suite 300, San Francisco, California 94105, USA.
*/
package com.firestartermedia.lib.as3.data.gdata
{
	import com.firestartermedia.lib.as3.data.DataService;
	import com.firestartermedia.lib.as3.events.DataServiceEvent;
	import com.firestartermedia.lib.as3.utils.YouTubeUtil;
	
	import flash.net.URLRequest;
	
	public class YouTubeGDataService extends DataService
	{
		public var GDATA_URL:String								= 'http://gdata.youtube.com/feeds/api/';
		public var PLAYLISTS_URL:String							= GDATA_URL + 'playlists';
		public var USERS_URL:String								= GDATA_URL + 'users';
		public var VIDEOS_URL:String							= GDATA_URL + 'videos';
		
		private var currentPlaylistEntries:Number;
		private var playlistEntries:Array;
		private var playlistId:String;
		private var playlistSearch:String;
		
		public function YouTubeGDataService()
		{
			super( DataServiceEvent.LOADING, DataServiceEvent.LOADED, DataServiceEvent.READY );
		}
		
		public function getVideoData(videoId:String):void
		{
			var request:URLRequest = new URLRequest( VIDEOS_URL + '/' + videoId );
			
			loader.load( request );
		}
		
		public function getPlaylistData(playlistId:String, startIndex:Number=1):void
		{
			var request:URLRequest = new URLRequest( PLAYLISTS_URL + '/' + playlistId + '?v=2&max-results=50&start-index=' + startIndex );
			
			loader.load( request );
		}
		
		public function searchPlaylistData(playlistId:String, playlistSearch:String):void
		{
			this.playlistId = playlistId;
			this.playlistSearch = playlistSearch; 
			
			handleReady = false;
			
			currentPlaylistEntries = 1;
			
			playlistEntries = [ ];
			
			addEventListener( DataServiceEvent.LOADED, handleSearchPlaylistDataComplete );
			
			getPlaylistData( playlistId );
		}
		
		private function handleSearchPlaylistDataComplete(e:DataServiceEvent):void
		{
			var data:XML = e.data as XML;
			var length:Number = data..*::itemsPerPage;
			var total:Number = data..*::totalResults;
			var entries:Array = YouTubeUtil.cleanGDataFeed( data );
			
			for each ( var entry:Object in entries )
			{
				if ( playlistEntries.length <= total )
				{
					playlistEntries.push( entry );
				}
			}
				
			currentPlaylistEntries += length;
			
			if ( currentPlaylistEntries >= total )
			{
				searchThroughPlaylistData();
			}
			else
			{				
				getPlaylistData( playlistId, currentPlaylistEntries );
			}
		}
		
		private function searchThroughPlaylistData():void
		{
			var matchEntries:Array = [ ]; 
			
			for each ( var entry:Object in playlistEntries )
			{
				if ( 
					entry.title.toLowerCase().search( playlistSearch.toLowerCase() ) != -1 || 
					entry.description.toLowerCase().search( playlistSearch.toLowerCase() ) != -1 || 
					entry.keywords.toLowerCase().search( playlistSearch.toLowerCase() ) != -1 
				)
				{
					matchEntries.push( entry );
				}
			}
			
			dispatchEvent( new DataServiceEvent( DataServiceEvent.READY, { entries: matchEntries } ) );
		}
	}
}