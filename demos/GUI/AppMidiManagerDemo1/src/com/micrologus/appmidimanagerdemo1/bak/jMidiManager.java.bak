package com.micrologus.appmidimanagerdemo1;

//by Marco Bramardi

//IOnDeviceOpenedListener
import java.io.IOException;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.graphics.SurfaceTexture;
import android.media.AudioManager;
import android.media.midi.MidiManager;
import android.media.midi.MidiManager.OnDeviceOpenedListener; // I don't know how to use this
import android.media.midi.MidiManager.DeviceCallback;
import android.media.midi.MidiDevice;
import android.media.midi.MidiDevice.MidiConnection;
import android.media.midi.MidiDeviceInfo;
import android.media.midi.MidiDeviceInfo.PortInfo;
import android.media.midi.MidiDeviceService;
import android.media.midi.MidiDeviceStatus;
import android.media.midi.MidiInputPort;
import android.media.midi.MidiOutputPort;
import android.media.midi.MidiReceiver;
import android.media.midi.MidiSender;
import android.net.Uri;
import android.os.Environment;
import android.os.Bundle;
import android.provider.Settings;
import android.view.Surface;
import android.util.Log;

public class jMidiManager  {

	// 1. The following constants must be in the same order as TDeviceInfoKind in midimanager.pas !
    // 2. Call getDeviceInfo(INFO_*) with these values to get details of the available MIDI devices
    public static final int INFO_ALL_XML        =  0;
    public static final int INFO_ALL_JSON       =  1;
    public static final int INFO_ALL_TEXT       =  2;
    public static final int INFO_INPUTS_XML     =  3;
    public static final int INFO_OUTPUTS_XML    =  4;
    public static final int INFO_INPUTS_JSON    =  5;
    public static final int INFO_OUTPUTS_JSON   =  6;
    public static final int INFO_INPUTS_TEXT    =  7;
    public static final int INFO_OUTPUTS_TEXT   =  8;

    // Note: INPUT and OUTPUT ares from the point of view of the device, not the app.
	// Therefore INPUT means "into the device" i.e. sending notes to play in a device,
	// while OUTPUT means reading noted from a device.

	// local variable "myStatus: holds the current status
	private int myStatus = STATUS_NONE;
	// values held by myStatus:
    public static final int STATUS_NONE     = 0;
	public static final int STATUS_READY    = 1; // this device supports MIDI
	public static final int STATUS_OPENING  = 2; // midiOpen was called, waiting for callback
	public static final int STATUS_OPEN     = 3; // MidiDevice has been opened
	public static final int STATUS_NO_MIDI  = -1; // this device does not support MIDI

    // parameters for doAction(_cmd, _param) method:
    public static final int CMD_SILENCE              = 0; // flush messages, all notes off immediately
	public static final int CMD_START                = 1; // set starting time for MIDI messages
	public static final int CMD_GET_STATUS           = 2; // return value of myStatus
	public static final int CMD_GET_DEVICE_ID        = 3; // returns current (open) device id
	public static final int CMD_GET_DEVICE_COUNT     = 4; // count how many devices, having in/out ports
       public static final int  CMD_GET_DEVICE_COUNT_INPUT   = 1; // count only input
       public static final int  CMD_GET_DEVICE_COUNT_OUTPUT  = 2; // count only output
       public static final int  CMD_GET_DEVICE_COUNT_ALL     = 3; // count both input and output
	public static final int CMD_ALL_NOTES_OFF        = 5; // all notes off at time T=_param
	public static final int CMD_MIDI_CLOSE           = 6; // close midi device if open

    public static final int EVENT_OPEN_RESULT        = 1; // callback to inform of status change

    // the usual LAMW fields:
	private long pascalObj = 0;
	private Controls controls  = null;
	private Context  context   = null;

    // MidiManager-related fields:
	private long             nanoTimeStart = 0; // should be initialized by doAction(CMD_START,0)
	private MidiManager      mm = null;     // actice instance of MidiManager
	// when a device is opened, these fields will be used:
	private MidiDeviceInfo   activeDeviceInfo  = null;  // DeviceInfo used for opening device
	private MidiDevice       activeMidiDevice  = null;  // instance of MidiDevice returned by openDevice()
	private int              activeDeviceId      = -1;  // from MidiDevice.getId() (values = 1, 2, etc.)
	private MidiInputPort    activeInputPort   = null;  // InputPort object
	private int              activeInpPortNumber = -1;  // from PortInfo.getPortNumber() (values = 0, 1, etc.)
	private MidiOutputPort   activeOutputPort  = null;  // OutputPort object
	private int              activeOutPortNumber = -1;  // same as previous, when Type=2

    public String debug = "";

    private void dbg (String msg) {
      //debug += msg + " (" + Integer.toString(myStatus) + ")\r\n";
      }

    public String getDebug() {
      return debug;
      }

	public jMidiManager (Controls _ctrls, long _Self) {
	    // initialize LAMW fields
	    pascalObj = _Self ;
	    controls  = _ctrls;
	    context   = _ctrls.activity;
		// Check if this device supports MIDI (API 23, i.e. Android 6.0 Marshmallow required)
        if (context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_MIDI)) {
           myStatus = STATUS_READY; // MIDI available here, API 23 and up, we're in business
		   mm = (MidiManager)context.getSystemService(Context.MIDI_SERVICE);

           if (mm != null) {
               mm.registerDeviceCallback(new MidiManager.DeviceCallback() {
                   @Override
                   public void onDeviceAdded(MidiDeviceInfo device) {
                       if (device != null) {  //TODO
                           //CALL PASCAL SIDE HERE?
                           //what data we need pass to pascal side
                           Bundle props = device.getProperties();
                           int deviceId = device.getId();
                           String deviceName = props.getString(device.PROPERTY_NAME, "");
                           String productId = props.getString(device.PROPERTY_PRODUCT, "");
                           String manufacture = props.getString(device.PROPERTY_MANUFACTURER, "");
                           controls.pOnMidiManagerDeviceAdded(pascalObj, deviceId, deviceName, productId,  manufacture);  //what more param we need here?
                       }
                   }
                   @Override
                   public void onDeviceRemoved( MidiDeviceInfo info ) {
                       if (info != null) {  //TODO
                           //CALL PASCAL SIDE HERE?
                           //what data we need pass to pascal side?
                           //controls.pOnMidiManageronDeviceRemoved(pascalObj, ....);// what more param we need here?
                           int deviceId = info.getId();
                           Bundle props = info.getProperties();
                           String deviceName = props.getString(info.PROPERTY_NAME, "");
                           String productId = props.getString(info.PROPERTY_PRODUCT, "");
                           String manufacture = props.getString(info.PROPERTY_MANUFACTURER, "");
                           controls.pOnMidiManagerDeviceRemoved(pascalObj, deviceId, deviceName, productId,  manufacture);  //what more param we need here?
                       }
                   }

               }, null);
           }
        } else {
          myStatus = STATUS_NO_MIDI; // MIDI not available on this system
        }
   	  }

	public void jFree() {
	    if (myStatus == STATUS_OPEN) {
		    this.midiClose(); // if playing, stop gracefully
		    mm = null;  // free object
		}
	}

	// mosty useful as a quick way to see if there are any MIDI devices available for use:
	public int getDeviceCount(int _what) {
        int c = 0;
	    if (myStatus > 0) {
            MidiDeviceInfo[] MDI = mm.getDevices();
            MidiDeviceInfo dev = null;
            Boolean countMe = false;
            int L = MDI.length;
            for (int i = 0; i < L; i++) {
                 dev = MDI[i];
                 switch (_what) {
                 case CMD_GET_DEVICE_COUNT_INPUT: // count only input
                     countMe = (dev.getInputPortCount() > 0);
                     break;
                 case CMD_GET_DEVICE_COUNT_OUTPUT: // count only output
                     countMe = (dev.getOutputPortCount() > 0);
                     break;
                 default:
                     countMe = true;
                 }
                 if (countMe) {c++;}
            }
            dev = null;
            MDI = null;
		}
        return c;
	}

	// collect info about available devices, and return as a string
	// see first "switch" statement for meaning of different _fmt values
    public String getDeviceInfo(int _fmt) {
        // get device list and initialize strings
		MidiDeviceInfo[] deviceList = mm.getDevices();
        int DL = deviceList.length;
        int count = 0;
        String s="";
        String io="";
        String type = "";
        String p = "";
        String prefix = "";
        String prefix2 = "";
        String comma = "";
        String val = "";

		// according to _fmt, open tags, etc.

        switch (_fmt) {

        // get details of all devices, in XML format
        case INFO_ALL_XML:
            s = "<devices count=\"" + Integer.toString(DL) + "\">";
            break;

        // get details of all devices, in JSON format
		case INFO_ALL_JSON:
            s = "{\"devices\":[";
            break;

        // get details of all devices, in TEXT format (name=value lines)
        case INFO_ALL_TEXT:
            s = "device_count=" + Integer.toString(DL);
            break;

        // get details of INPUT devices only, in XML format
        case INFO_INPUTS_XML:
            io = "1";
            s = "<inputs>";
            break;

        // get details of INPUT devices only, in JSON format
        case INFO_INPUTS_JSON:
            io = "1";
            s = "{\"inputs\":[";
            break;

        // get details of INPUT devices only, in TEXT format (name=value lines)
        case INFO_INPUTS_TEXT:
            io = "1";
            break;

        // get details of OUTPUT devices only, in XML format
        case INFO_OUTPUTS_XML:
            io = "2";
            s = "<outputs>";
            break;

        // get details of OUTPUT devices only, in JSON format
        case INFO_OUTPUTS_JSON:
            io = "2";
            s = "{\"outputs\":[";
            break;

        // get details of OUTPUT devices only, in TEXT format (name=value lines)
        case INFO_OUTPUTS_TEXT:
            io = "2";
            break;
        }

        for (int i = 0; i < DL; i++) {
		    // get info for every available device:
            MidiDeviceInfo dev = deviceList[i];
            if (dev.isPrivate()) {p="1";} else {p="0";}
            Bundle props;
            props = dev.getProperties();
            PortInfo[] portList = dev.getPorts();
            int PL = portList.length;

            switch (_fmt) {
            case INFO_ALL_XML:
                s += "\r\n\t<device>";
                s += "\r\n\t\t<Id>" + Integer.toString(dev.getId()) + "</Id>";
                s += "\r\n\t\t<Type>" + Integer.toString(dev.getType()) + "</Type>";
                s += "\r\n\t\t<InputPortCount>" + Integer.toString(dev.getInputPortCount()) + "</InputPortCount>";
                s += "\r\n\t\t<OutputPortCount>" + Integer.toString(dev.getOutputPortCount()) + "</OutputPortCount>";
                s += "\r\n\t\t<Private>" + p + "</Private>";
                s += "\r\n\t\t<properties>";
                for (String key : props.keySet()) {
                    s += "\r\n\t\t\t<"+key+">" + props.get(key).toString() + "</"+key+">";
                }
                s += "\r\n\t\t</properties>";
                s += "\r\n\t\t<ports count=\"" + Integer.toString(PL) + "\">";
                break;
            case INFO_ALL_JSON:
                if (i>0) {s+=", ";}
                s += "\r\n{";
                s += "\"Id\":\"" + Integer.toString(dev.getId()) + "\",";
                s += "\"Type\":\"" + Integer.toString(dev.getType()) + "\",";
                s += "\"InputPortCount\":\"" + Integer.toString(dev.getInputPortCount()) + "\",";
                s += "\"OutputPortCount\":\"" + Integer.toString(dev.getOutputPortCount()) + "\",";
                s += "\"Private\":\"" + p + "\",";
                s += "\r\n\t\"properties\": {";
                comma = "";
                for (String key : props.keySet()) {
                  s += comma + "\"" + key + "\":\"" + props.get(key).toString() + "\"";
                  comma = ", ";
                }
                s += "}";
                break;
            case INFO_ALL_TEXT:
                prefix = "\r\ndevice_" + Integer.toString(i) + "_";
                s += prefix + "Id=" + Integer.toString(dev.getId());
                s += prefix + "Type=" + Integer.toString(dev.getType());
                s += prefix + "InputPortCount="  + Integer.toString(dev.getInputPortCount());
                s += prefix + "OutputPortCount=" + Integer.toString(dev.getOutputPortCount());
                s += prefix + "Private=" + p;
                for (String key : props.keySet()) {
                  s += prefix + "property_" + key + "=" + props.get(key).toString();
                }
                s += prefix + "port_count=" + Integer.toString(PL);
                break;
            }
            for (int j = 0; j < PL; j++) {
                PortInfo pi;
                pi = portList[j];
                type = Integer.toString(pi.getType());

                switch (_fmt) {

                case INFO_ALL_XML:
                    s += "\r\n\t\t\t<port>";
                    s += "\r\n\t\t\t\t<Name>" + pi.getName() + "</Name>";
                    s += "\r\n\t\t\t\t<Type>" + type + "</Type>";
                    // type = 1 is TYPE_INPUT and type = 2 is TYPE_OUTPUT
                    s += "\r\n\t\t\t\t<PortNumber>" + Integer.toString(pi.getPortNumber()) + "</PortNumber>";
                    s += "\r\n\t\t\t</port>";
                    break;

                case INFO_ALL_JSON:
                    if (j==0) {
                        s += ", \r\n\t\"ports\": [";
                    } else {
                      s += ", ";
                    }
                    s += "{\"Name\"=\"" + pi.getName() + "\", ";
                    s += " \"Type\"=\"" + type + "\", ";
                    s += " \"PortNumber\"=\"" + Integer.toString(pi.getPortNumber()) + "\"}";
                    if (j==PL-1) {
                      s += "]";
                    }
                    break;

                case INFO_ALL_TEXT:
                    prefix2 = prefix + "port_" + Integer.toString(j) + "_";
                    s += prefix2 + "Name=" + pi.getName();
                    s += prefix2 + "Type=" + type;
                    s += prefix2 + "PortNumber=" + Integer.toString(pi.getPortNumber());
                    break;

                case INFO_INPUTS_TEXT:
                case INFO_OUTPUTS_TEXT:
                    if (type.equals(io)) {
				        String t = props.getString(dev.PROPERTY_NAME, "");
				        if (t=="") { t = props.getString(dev.PROPERTY_PRODUCT, ""); }
				        if (t=="") { t = props.getString(dev.PROPERTY_MANUFACTURER, "MIDI-" + type); }
                        prefix = "\r\nport_" + Integer.toString(count) + "_";
                        s += prefix + "Title=" + t;
                        s += prefix + "Id=" + Integer.toString(dev.getId());
                        s += prefix + "PortNumber=" + Integer.toString(pi.getPortNumber());
                        s += prefix + "MyId=" +
                           "D" + Integer.toString(dev.getId()) +
                           "P" + Integer.toString(pi.getPortNumber());
                        count += 1;
                    }
                    break;

                case INFO_INPUTS_JSON:
                case INFO_OUTPUTS_JSON:
                    if (type.equals(io)) {
                        s += comma + "{";

                        s += "\"MidiDevice_Id\":\"" +
                          Integer.toString(dev.getId()) + "\", ";
                        s += "\"MidiDevice_Type\":\"" +
                          Integer.toString(dev.getType()) + "\", ";

                        s += "\"MidiDevice_manufacturer\":\"" +
                          props.getString(dev.PROPERTY_MANUFACTURER, "N/A") + "\", ";
                        s += "\"MidiDevice_product\":\"" +
                          props.getString(dev.PROPERTY_PRODUCT, "N/A") + "\", ";
                        s += "\"MidiDevice_name\":\"" +
                          props.getString(dev.PROPERTY_NAME, "N/A") + "\", ";

                        s += "\"Port_Name\":\"" +
                          pi.getName() + "\", ";
                        s += "\"Port_Type\":\"" +
                          type + "\", ";
                        s += "\"Port_PortNumber\":\"" +
                          Integer.toString(pi.getPortNumber()) + "\", ";

                        s += "\"MyId\":\"" +
                          "D" + Integer.toString(dev.getId()) +
                          "P" + Integer.toString(pi.getPortNumber()) + "\"}";

                        comma = ", ";
                    }
                    break;

                case INFO_INPUTS_XML:
                case INFO_OUTPUTS_XML:
                    if (type.equals(io)) {
                      s += "\r\n\t<port>";
                      s += "\r\n\t\t<MidiDevice_Id>" +
                        Integer.toString(dev.getId()) +
                        "</MidiDevice_Id>";
                      s += "\r\n\t\t<MidiDevice_Type>" +
                        Integer.toString(dev.getType()) +
                        "</MidiDevice_Type>";
                      s += "\r\n\t\t<MidiDevice_manufacturer>" +
                        props.getString(dev.PROPERTY_MANUFACTURER, "N/A") +
                        "</MidiDevice_manufacturer>";
                      s += "\r\n\t\t<MidiDevice_product>" +
                        props.getString(dev.PROPERTY_PRODUCT, "N/A") +
                        "</MidiDevice_product>";
                      s += "\r\n\t\t<MidiDevice_name>" +
                        props.getString(dev.PROPERTY_NAME, "N/A") +
                        "</MidiDevice_name>";
                      s += "\r\n\t\t<Port_Name>" + pi.getName() + "</Port_Name>";
                      s += "\r\n\t\t<Port_Type>" + type + "</Port_Type>";
                      s += "\r\n\t\t<Port_PortNumber>" + Integer.toString(pi.getPortNumber()) + "</Port_PortNumber>";
                      // for convenience, I can later open a specific port by a unique ID
                      s += "\r\n\t\t<MyId>" +
                        "D" + Integer.toString(dev.getId()) +
                        "P" + Integer.toString(pi.getPortNumber()) + "</MyId>";
                      s += "\r\n\t</port>";
                    }
                    break;
                } // end switch for port
                pi = null;
            }  // end switch for device
            portList = null;
            dev = null;

            // close tags for this device
            switch (_fmt) {
            case INFO_ALL_XML:
                s += "\r\n\t\t</ports>";
                s += "\r\n\t</device>";
                break;
            case INFO_ALL_JSON:
                s += "}";
                break;
            case INFO_ALL_TEXT:
                break;
            }
        }
        // close tags for whole list
        deviceList = null;
        switch (_fmt) {
        case INFO_ALL_JSON:
            s += "\r\n]}";
            break;
        case INFO_ALL_TEXT:
            break;
        case INFO_ALL_XML:
            s += "\r\n</devices>";
            break;
        case INFO_INPUTS_XML:
            s += "\r\n</inputs>";
            break;
        case INFO_INPUTS_JSON:
            s += "\r\n]}";
            break;
        case INFO_OUTPUTS_XML:
            s += "\r\n</outputs>";
            break;
        case INFO_OUTPUTS_JSON:
            s += "\r\n]}";
            break;
        case INFO_INPUTS_TEXT:
        case INFO_OUTPUTS_TEXT:
            s = "port_count=" + Integer.toString(count) + s;
            break;
        }
        return s;
    }

    // open output port
	public int midiOpenOutput(int _deviceId, int _portNumber) {
       return 0;
       // to be implemented next...
    }

	//if port isn't opened by callback method, make sure it is open here:
    private void openInputPort() {
	    if ((activeInputPort == null) && (myStatus==STATUS_OPEN) && (activeMidiDevice != null)) {
		   activeInputPort = activeMidiDevice.openInputPort(activeInpPortNumber);
           nanoTimeStart = System.nanoTime(); // if you don't call
		}
	}

	// remove all pending queued messages
    public void doFlush() {
        if (activeInputPort != null) {
		    try {
                activeInputPort.flush();
			} catch (IOException e) {
	            e.printStackTrace();
	      	}
		}
	}

    public int sendMidiMessage(int _b1, int _b2, int _b3, long _timestamp) {
		this.openInputPort();
		if (myStatus != STATUS_OPEN) { return -10; }
		byte[] buffer = new byte[32];
		int numBytes = 0;
		buffer[numBytes++] = (byte)_b1; // note on
		buffer[numBytes++] = (byte)_b2; // pitch is middle C
		buffer[numBytes++] = (byte)_b3; // max velocity
		int offset = 0;
		if (_timestamp == 0) {
			// post is non-blocking
		  try {
			activeInputPort.send(buffer, offset, numBytes);
	      }
	      catch (IOException e) {
	         e.printStackTrace();
	      }
		} else {
		  	if (nanoTimeStart==0) { // forgot to call doAction(CMD_START,0) to start
              nanoTimeStart = System.nanoTime();
			}
			final long NANOS_PER_MSEC = 1000000L;
			long future = nanoTimeStart + (_timestamp * NANOS_PER_MSEC);
  			try {
				activeInputPort.send(buffer, offset, numBytes, future);
			} catch (IOException e) {
	         e.printStackTrace();
	      	}
		}
		return myStatus;
	}

    public void doAllNotesOff(long _timestamp) {
        if (activeInputPort != null) {
            for (int i = 0; i < 16; i++) {
                sendMidiMessage(0xB0 + i, 123, 0, _timestamp);
            }
		}
	}

    public int doAction(int _cmd, long _param) {
	    if (_cmd == CMD_SILENCE) { // Silence: flush and all notes off
		    doFlush();
			doAllNotesOff(0); // -1 = all channels, 0 = immediately
		}
	    if (_cmd == CMD_START) { // Start reference time
			nanoTimeStart = System.nanoTime();
		}
	    if (_cmd == CMD_GET_STATUS) { // get status
			return myStatus;
		}
	    if (_cmd == CMD_ALL_NOTES_OFF) { // Silence: flush and all notes off
			doAllNotesOff(_param); // all notes off at time _param
		}
	    if (_cmd == CMD_GET_DEVICE_COUNT) { // Silence: flush and all notes off
			return getDeviceCount((int)_param); // all notes off at time _param
		}
	    if (_cmd == CMD_MIDI_CLOSE) { // Silence: flush and all notes off
			return midiClose(); // all notes off at time _param
		}
		return _cmd;
	}


    // open input port
    public int midiOpenInput(int _deviceId, int _portNumber) {
        dbg("midiOpenInput");
        boolean launched = false;
		if (myStatus != STATUS_READY) {
          dbg("midiOpenInput.Fail not ready");
          return myStatus;
        } // either open (myst close it before open a new one) or pending opening
		MidiDeviceInfo[] deviceList = mm.getDevices();
		int DL = deviceList.length;
		for (int i = 0; i < DL; i++) {
			if (deviceList[i].getId()==_deviceId) { // found device, open it and save  port #
                myStatus = STATUS_OPENING; // means pengin opening
                dbg("midiOpenInput.Found device, started opening");
                activeDeviceId = _deviceId;
                activeInpPortNumber = _portNumber; // save for later, after deve opened, must use this port
                activeDeviceInfo = deviceList[i];
                launched = true;
			    final int pn = _portNumber;
                //final Controls ctls = controls;
                mm.openDevice(activeDeviceInfo,
                  new MidiManager.OnDeviceOpenedListener() {
                    @Override
                    public void onDeviceOpened(MidiDevice device) {
                        activeMidiDevice = device;
                        int newStatus = 0;
                        if (device == null) {
                            activeInputPort = null;
                            dbg("midiOpenInput.callback fail null");
                        } else {
                            activeInputPort = device.openInputPort(pn);
                        }
                        if (activeInputPort!=null) {
					        newStatus = STATUS_OPEN;
                            dbg("midiOpenInput.callback success ...");
                        } else {
                            // Port failed to open, undo everything:
                            activeDeviceInfo = null;
                            activeMidiDevice = null;
						    activeDeviceId = 0;
						    activeInpPortNumber = 0;
						    newStatus = STATUS_READY;
                            dbg("midiOpenInput.callback port fail ...");
                        }
                        myStatus = newStatus;
	                    //ctls.pOnMidiDeviceEvent(pascalObj, EVENT_OPEN_RESULT, newStatus);
                    }
                  },
				  null);
                dbg("midiOpenInput.launched opening...");
                return myStatus;
            }
        }  // end of for loop
        deviceList = null;
        if (! launched) {
          dbg("midiOpenInput.did not launch opening! why?");
        }
        return myStatus; // could not find specified device, exit with status 1
    }

    public int midiClose() {
        dbg("midiClose");
        if (myStatus == STATUS_OPEN) {
            // all notes off
            doAllNotesOff(0);
            if (activeMidiDevice != null) {
                try {
                    activeMidiDevice.close();
                } catch (IOException e) {
	                e.printStackTrace();
                }
            }
			activeDeviceInfo = null;
			activeMidiDevice = null;
			activeInputPort  = null;
			activeDeviceId   = 0;
            activeInpPortNumber = 0;
            myStatus = STATUS_READY; // ready, nothing is open
            dbg("midiClose.OK");
        } else {
            dbg("midiClose.fail" + Integer.toString(myStatus));
        }
        return myStatus;
    }

}
