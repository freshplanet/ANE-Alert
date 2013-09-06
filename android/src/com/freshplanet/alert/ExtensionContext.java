//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

package com.freshplanet.alert;

import java.util.HashMap;
import java.util.Map;

import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.DialogInterface.OnCancelListener;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.freshplanet.alert.functions.AirAlertShowAlert;

public class ExtensionContext extends FREContext implements OnClickListener, OnCancelListener
{
	// Public API
	
	@Override
	public void dispose() { }

	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		
		functionMap.put("AirAlertShowAlert", new AirAlertShowAlert());
		
		return functionMap;	
	}
	
	public void onClick(DialogInterface dialog, int which)
	{
		String buttonIndex = (which == DialogInterface.BUTTON_POSITIVE) ? "1" : "0";
		
		dispatchStatusEventAsync("CLICK", buttonIndex);
	}

	public void onCancel(DialogInterface dialog)
	{
		dispatchStatusEventAsync("CLICK", "0");
	}
}
