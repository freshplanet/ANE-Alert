/*
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.freshplanet.ane.AirAlert.functions;

import android.app.AlertDialog;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirAlert.AirAlertExtension;
import com.freshplanet.ane.AirAlert.AirAlertExtensionContext;

public class ShowAlertFunction extends BaseFunction {
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);

		String title = getStringFromFREObject(args[0]);
		String message = getStringFromFREObject(args[1]);
		String button1 = getStringFromFREObject(args[2]);
		String button2 = args.length > 3 ? getStringFromFREObject(args[3]) : null;

		// Create alert builder with a theme depending on Android version
		AlertDialog.Builder alertBuilder = new AlertDialog.Builder(context.getActivity());

		// Setup and show the alert
		alertBuilder.setTitle(title).setMessage(message).setNeutralButton(button1, (AirAlertExtensionContext)AirAlertExtension.context).setOnCancelListener((AirAlertExtensionContext)AirAlertExtension.context);
		if (button2 != null) {
			alertBuilder.setPositiveButton(button2, (AirAlertExtensionContext)AirAlertExtension.context);
		}

		AlertDialog alertDialog = alertBuilder.create();
		alertDialog.setCanceledOnTouchOutside(false);
		alertDialog.show();

		return null;

	}

}