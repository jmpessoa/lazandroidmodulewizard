package org.lamw.appnetapidemo1;

import android.content.Context;
 
/*Draft java code by "Lazarus Android Module Wizard" [9/19/2020 15:29:08]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jNetApi /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;
  
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jNetApi(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

	static public native boolean NetApiOpenDevice(String  ip, int iPort);
	static public native void NetApiCloseDevice();
	static public native boolean NetApiGetDeviceSystemInfo(byte bDevAdr, byte pucSystemInfo[]);
	static public native boolean NetApiReadDeviceOneParam(byte bDevAdr,byte pucDevParamAddr,byte pValue[]);
	static public native boolean NetApiSetDeviceOneParam(byte bDevAdr,byte pucDevParamAddr,byte pValue);
	static public native boolean NetApiStopRead(byte bDevAdr);
	static public native boolean NetApiStartRead(byte bDevAdr);
	static public native boolean NetApiInventoryG2(byte bDevAdr, byte[] pBuffer, int[] Totallen, int[] CardNum);
	static public native boolean NetApiWriteEPCG2(byte bDevAdr, byte[] Password, byte[] WriteEPC, byte WriteEPClen);
	static public native boolean NetApiReadCardG2(byte bDevAdr, byte[] Password, byte Mem, byte WordPtr, byte ReadEPClen, byte[] Data);
	static public native boolean NetApiWriteCardG2(byte bDevAdr, byte[] Password, byte Mem, byte WordPtr, byte Writelen, byte[] Writedata);
	static public native boolean NetApiRelayOn(byte bDevAdr);
	static public native boolean NetApiRelayOff(byte bDevAdr);
	static public native boolean NetApiClearTagBuf();
	static public native byte NetApiGetTagBuf(byte[] pBuf, int[] pLength, int[] pTagNumber);
	static public native boolean NetApiSetFreq(byte bDevAdr, byte[] pFreq);
	static public native boolean NetApiReadFreq(byte bDevAdr, byte[] pFreq);

	//Pascal Interface
	public boolean OpenDevice(String ip, int iPort) {
           return NetApiOpenDevice(ip, iPort);
	}

	public void CloseDevice() {
		NetApiCloseDevice();
	}

	public boolean GetDeviceSystemInfo(byte bDevAdr, byte[] pucSystemInfo) {
	   return NetApiGetDeviceSystemInfo(bDevAdr, pucSystemInfo);
	}

	public boolean ReadDeviceOneParam(byte bDevAdr, byte pucDevParamAddr, byte[] pValue) {
		return NetApiReadDeviceOneParam(bDevAdr,pucDevParamAddr,pValue);
	}

	public boolean SetDeviceOneParam(byte bDevAdr, byte pucDevParamAddr, byte pValue) {
		return NetApiSetDeviceOneParam(bDevAdr,pucDevParamAddr,pValue);
	}

	public boolean StopRead(byte bDevAdr) {
		return NetApiStopRead(bDevAdr);
	}

	public boolean StartRead(byte bDevAdr) {
		return NetApiStartRead(bDevAdr);
	}

	public boolean InventoryG2(byte bDevAdr, byte[] pBuffer, int[] Totallen, int[] CardNum) {
		return NetApiInventoryG2(bDevAdr, pBuffer, Totallen, CardNum);
	}

	public boolean WriteEPCG2(byte bDevAdr, byte[] Password, byte[] WriteEPC, byte WriteEPClen) {
		return  NetApiWriteEPCG2(bDevAdr,Password, WriteEPC,WriteEPClen);
	}

	public boolean ReadCardG2(byte bDevAdr, byte[] Password, byte Mem, byte WordPtr, byte ReadEPClen, byte[] Data) {
		return  NetApiReadCardG2(bDevAdr, Password, Mem, WordPtr, ReadEPClen, Data);
	}

	public boolean WriteCardG2(byte bDevAdr, byte[] Password, byte Mem, byte WordPtr, byte Writelen, byte[] Writedata) {
		return NetApiWriteCardG2(bDevAdr,  Password, Mem, WordPtr, Writelen, Writedata);
	}

	public boolean RelayOn(byte bDevAdr) {
		return NetApiRelayOn(bDevAdr);
	}

	public boolean RelayOff(byte bDevAdr) {
		return NetApiRelayOff(bDevAdr);
	}

	public boolean ClearTagBuf() {
		return NetApiClearTagBuf();
	}

	public byte GetTagBuf(byte[] pBuf, int[] pLength, int[] pTagNumber) {
		return NetApiGetTagBuf(pBuf, pLength, pTagNumber);
	}

	public boolean SetFreq(byte bDevAdr, byte[] pFreq) {
		return NetApiSetFreq(bDevAdr, pFreq);
	}

	public boolean ReadFreq(byte bDevAdr, byte[] pFreq) {
		return NetApiReadFreq(bDevAdr, pFreq);
	}
}
