package org.mconf.mobile.view.navigation.pages.videochat
{
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	import org.mconf.mobile.model.IUserSession;
	import org.mconf.mobile.model.User;
	import org.mconf.mobile.model.UserSession;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class VideoChatViewMediator extends Mediator
	{
		[Inject]
		public var view: IVideoChatView;
		
		[Inject]
		public var userSession: IUserSession;
		
		override public function initialize():void
		{
			Log.getLogger("org.mconf.mobile").info(String(this));
			
			userSession.userlist.newUserSignal.add(newUserHandler);
			userSession.userlist.userChangeSignal.add(userChangeHandler);
			
			// find all currently open streams
			var users:ArrayCollection = userSession.userlist.users;
			for (var i:Number=0; i < users.length; i++) {
				var u:User = users.getItemAt(i) as User;
				if (u.hasStream) {
					startStream(u.name, u.streamName);
				}
			}
		}
		
		override public function destroy():void
		{
			view.cleanUpVideos();
			
			super.destroy();
			
			view.dispose();
			view = null;
		}
		
		private function newUserHandler(user:User):void {
			if (user.hasStream)
				startStream(user.name, user.streamName);
		}
		
		private function userChangeHandler(user:User, property:String):void {
			if (property == "hasStream")
				startStream(user.name, user.streamName);
		}
		
		private function startStream(name:String, streamName:String):void {
			var resolution:Object = getVideoResolution(streamName);
			
			if (resolution) {
				trace(ObjectUtil.toString(resolution));
				var width:Number = Number(String(resolution.dimensions[0]));
				var length:Number = Number(String(resolution.dimensions[1]));
				view.startStream(userSession.videoConnection.connection, name, streamName, resolution.userID, width, length);
			}
		}
		
		protected function getVideoResolution(stream:String):Object {
			var pattern:RegExp = new RegExp("(\\d+x\\d+)-([A-Za-z0-9]+)-\\d+", "");
			if (pattern.test(stream)) {
				trace("The stream name is well formatted [" + stream + "]");
				trace("Stream resolution is [" + pattern.exec(stream)[1] + "]");
				trace("Userid [" + pattern.exec(stream)[2] + "]");
				return {userID: pattern.exec(stream)[2], dimensions:pattern.exec(stream)[1].split("x")};
			} else {
				trace("The stream name doesn't follow the pattern <width>x<height>-<userId>-<timestamp>. However, the video resolution will be set to 320x240");
				return null;
			}
		}
	}
}