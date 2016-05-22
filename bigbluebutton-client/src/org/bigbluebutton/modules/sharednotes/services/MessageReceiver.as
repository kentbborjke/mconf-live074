/**
 * BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
 * 
 * Copyright (c) 2012 BigBlueButton Inc. and by respective authors (see below).
 *
 * This program is free software; you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by the Free Software
 * Foundation; either version 3.0 of the License, or (at your option) any later
 * version.
 * 
 * BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along
 * with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
 *
 */
package org.bigbluebutton.modules.sharednotes.services
{
  import flash.events.IEventDispatcher;
  
  import org.bigbluebutton.core.BBB;
  import org.bigbluebutton.core.UsersUtil;
  import org.bigbluebutton.main.model.users.IMessageListener;
  import org.bigbluebutton.modules.sharednotes.events.CurrentDocumentEvent;
  import org.bigbluebutton.modules.sharednotes.events.SharedNotesEvent;
  import org.bigbluebutton.modules.sharednotes.events.ReceivePatchEvent;
  
  public class MessageReceiver implements IMessageListener {
    private static const LOG:String = "SharedNotes::MessageReceiver - ";
    
    public var dispatcher:IEventDispatcher;
    
    public function MessageReceiver()
    {
      BBB.initConnectionManager().addMessageListener(this);
    }
    
    public function onMessage(messageName:String, message:Object):void
    {
      switch (messageName) {
        case "PatchDocumentCommand":
          handlePatchDocumentCommand(message);
          break;			
        case "GetCurrentDocumentCommand":
          handleGetCurrentDocumentCommand(message);
          break;	
        case "CreateAdditionalNotesCommand":
          handleCreateAdditionalNotesCommand(message);
          break;  
        case "DestroyAdditionalNotesCommand":
          handleDestroyAdditionalNotesCommand(message);
          break;	
        default:
          //   LogUtil.warn("Cannot handle message [" + messageName + "]");
      }
    }
    
    private function handlePatchDocumentCommand(message:Object):void {
      if (message.userID == UsersUtil.getMyUserID()) {
        return;
      }

      trace(LOG + "Handling patch document message [" + message + "]");

      var receivePatchEvent:ReceivePatchEvent = new ReceivePatchEvent();
      receivePatchEvent.noteId = message.noteID;
      receivePatchEvent.patch = message.patch;
      dispatcher.dispatchEvent(receivePatchEvent);
    }
        
    private function handleGetCurrentDocumentCommand(message:Object):void {
      trace(LOG + "Handling get current document message [" + message + "]");
      var notes:Object = JSON.parse(message.notes); 
      
      var currentDocumentEvent:CurrentDocumentEvent = new CurrentDocumentEvent();
      currentDocumentEvent.document = notes;
      dispatcher.dispatchEvent(currentDocumentEvent);
    }
    
    private function handleCreateAdditionalNotesCommand(message:Object):void {
      trace(LOG + "Handling create additional notes message [" + message + "]");
      
      var e:SharedNotesEvent = new SharedNotesEvent(SharedNotesEvent.CREATE_ADDITIONAL_NOTES_REPLY_EVENT);
      e.payload.notesId = message.noteID;
      e.payload.noteName = message.noteName;
      dispatcher.dispatchEvent(e);
    }
    
    private function handleDestroyAdditionalNotesCommand(message:Object):void {
      trace(LOG + "Handling destroy additional notes message [" + message + "]");
      
      var e:SharedNotesEvent = new SharedNotesEvent(SharedNotesEvent.DESTROY_ADDITIONAL_NOTES_REPLY_EVENT);
      e.payload.notesId = message.noteID;
      dispatcher.dispatchEvent(e);
    }
  }
}