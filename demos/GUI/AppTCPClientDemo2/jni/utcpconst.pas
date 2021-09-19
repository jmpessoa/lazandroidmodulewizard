unit uTCPConst;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

resourcestring
  //TCPSockets
  rsInvalidMessage = 'Invalid message.';
  rsInvalidUserNameOrPassword = 'Invalid username or password.';
  rsInvalidDuplicateUser = 'Username already exists. Please enter a different username.';
  rsConnectionRejectedInvalid = 'Connection rejected from: %s. Invalid username or password.';
  rsConnectionRejectedDuplicate = 'Connection rejected form: %s. Duplicate username.';
  rsConnectionAccepted = 'Connection accepted from: %s. "%s" successfully loged in.';
  rsMessageSent = 'Message "%s" sent to %s.';
  rsMessageSentError = 'Error sending message "%s" : ';
  rsMessageRecv = 'Message "%s" received from %s.';
  rsMessageRecvError = 'Error receiving message "%s" :';
  rsStreamSent = 'Stream with size %s sent to %s.';
  rsStreamSentError = 'Error sending stream to %s : ';
  rsStreamRecv = 'Stream with size %s received from %s.';
  rsStreamRecvError = 'Error receiving stream from "%s" :';
  rsFileSent = 'File with size %s sent to %s.';
  rsFileSentError = 'Error sending file to %s : ';
  rsFileRecv = 'File with size %s received from %s.';
  rsFileRecvError = 'Error receiving file from "%s" :';
  rsInvalidDirectory = 'Invalid download directory. Please specify a valid folder in options dialog.';
  rsPing = 'Reply from %s in %s ms.';

implementation

end.

