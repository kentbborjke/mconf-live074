package org.bigbluebutton.api.messaging.messages;

public class UserJoined implements IMessage {
  public final String meetingId;
  public final String userId;
  public final String externalUserId;
  public final String name;
  public final String role;
  public final Boolean guest;
  public final Boolean waitingForAcceptance;
  
  public UserJoined(String meetingId, String userId, String externalUserId, String name, String role, Boolean guest, Boolean waitingForAcceptance) {
  	this.meetingId = meetingId;
  	this.userId = userId;
  	this.externalUserId = externalUserId;
  	this.name = name;
  	this.role = role;
  	this.guest = guest;
  	this.waitingForAcceptance = waitingForAcceptance;
  }
}
