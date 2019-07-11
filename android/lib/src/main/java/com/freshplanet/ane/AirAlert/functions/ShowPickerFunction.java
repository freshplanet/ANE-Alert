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

import android.view.ViewGroup;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirAlert.AirPickerExtensionContext;


public class ShowPickerFunction extends BaseFunction {
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);

		if(AirPickerExtensionContext.pickerControl != null) {
			ViewGroup rootContainer = context.getActivity().findViewById(android.R.id.content);
			rootContainer = (ViewGroup) rootContainer.getChildAt(0);
			rootContainer.addView(AirPickerExtensionContext.pickerControl);
		}

		return null;

	}

}