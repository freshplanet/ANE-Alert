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

package com.freshplanet.alert.functions;

import android.annotation.TargetApi;
import android.app.AlertDialog;
import android.os.Build;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.alert.Extension;

@TargetApi(18)
public class AirAlertShowAlert implements FREFunction
{
	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		
		// Retrieve alert parameters
		String title = null;
		String message = null;
		String button1 = null;
		String button2 = null;
		try
		{
			title = args[0].getAsString();
			message = args[1].getAsString();
			button1 = args[2].getAsString();
			if (args.length > 3) button2 = args[3].getAsString();
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return null;
		}
		
		// Create alert builder with a theme depending on Android version
		AlertDialog.Builder alertBuilder;
		
		int themeDevice;
		int themeHold;
		if ( "LIGHT".equals ( Extension.theme ) )
		{
			//	Theme "Light"
			themeDevice = AlertDialog.THEME_DEVICE_DEFAULT_LIGHT;
			themeHold = AlertDialog.THEME_HOLO_LIGHT;
		} else {
			//	Theme "Dark"
			themeDevice = AlertDialog.THEME_DEVICE_DEFAULT_DARK;
			themeHold = AlertDialog.THEME_HOLO_DARK;
		}
			
		if ( Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH )
		{
			alertBuilder = new AlertDialog.Builder(context.getActivity(), themeDevice);
		}
		else if ( Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB )
		{
			alertBuilder = new AlertDialog.Builder(context.getActivity(), themeHold);
		}
		else
		{
			alertBuilder = new AlertDialog.Builder(context.getActivity());
		}
		
		
		
		
		// Setup and show the alert
		alertBuilder.setTitle(title).setMessage(message).setNeutralButton(button1, Extension.context).setOnCancelListener(Extension.context);
		if (button2 != null)
		{
			alertBuilder.setPositiveButton(button2, Extension.context);
		}

		AlertDialog alertDialog = alertBuilder.create();
		alertDialog.setCanceledOnTouchOutside(false);
		alertDialog.show();
		
		return null;
	}
}
