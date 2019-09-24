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


import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.Log;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.NumberPicker;
import android.widget.RelativeLayout;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirAlert.AirPickerExtensionContext;

import java.lang.reflect.Field;
import java.util.List;


public class InitPickerFunction extends BaseFunction {


	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);

		final FREContext finalContext = context;

		String doneLabel = getStringFromFREObject(args[0]);
		String cancelLabel = getStringFromFREObject(args[1]);
		int posX = getIntFromFREObject(args[2]);
		int posY = getIntFromFREObject(args[3]);
		int Width = getIntFromFREObject(args[4]);
		int Height = getIntFromFREObject(args[5]);
		final List<String> items = getListOfStringFromFREArray((FREArray) args[6]);

		int toolbarHeight = Math.round(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 40, Resources.getSystem().getDisplayMetrics()));
		Height -= toolbarHeight;
		posY += toolbarHeight;

		RelativeLayout layout = new RelativeLayout(context.getActivity().getApplicationContext());
		RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(Width, Height);
		layout.setLayoutParams(layoutParams);

		RelativeLayout toolbar = new RelativeLayout(context.getActivity().getApplicationContext());
		toolbar.setBackgroundColor(Color.LTGRAY);
		RelativeLayout.LayoutParams toolbarLayoutParams = new RelativeLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, toolbarHeight);
		toolbar.setLayoutParams(toolbarLayoutParams);
		toolbar.setY(0);
		toolbar.setX(0);
		layout.addView(toolbar);


		View.OnTouchListener buttonTouchListener = new View.OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				Button button = (Button) v;
				switch(event.getAction()) {
					case MotionEvent.ACTION_DOWN:
						// PRESSED
						button.setTextColor(Color.GRAY);
						break;
					case MotionEvent.ACTION_UP:
					case MotionEvent.ACTION_CANCEL:
						// RELEASED
						button.setTextColor(Color.WHITE);
						break;
				}
				return false;
			}
		};

		final Button cancelButton = new Button(context.getActivity().getApplicationContext());
		cancelButton.setText(cancelLabel);
		cancelButton.setBackground(null);
		cancelButton.setTextColor(0xffffffff);
		RelativeLayout.LayoutParams cancelButtonLayoutParams =  new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, toolbarHeight);
		cancelButton.setLayoutParams(cancelButtonLayoutParams);
		cancelButton.setX(0);
		cancelButton.setY(0);
		toolbar.addView(cancelButton);
		cancelButton.setOnTouchListener(buttonTouchListener);
		cancelButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if(AirPickerExtensionContext.pickerControl != null) {
					ViewGroup rootContainer = finalContext.getActivity().findViewById(android.R.id.content);
					rootContainer = (ViewGroup) rootContainer.getChildAt(0);
					rootContainer.removeView(AirPickerExtensionContext.pickerControl);
				}
				try {
					finalContext.dispatchStatusEventAsync("PICKER_CANCELED", "");
				} catch (Exception e) {
					Log.e("AirAlert", "error dispatching event", e);
				}
			}
		});


		final Button doneButton = new Button(context.getActivity().getApplicationContext());
		doneButton.setText(doneLabel);
		doneButton.setBackground(null);
		doneButton.setTextColor(0xffffffff);
		RelativeLayout.LayoutParams doneButtonLayoutParams =  new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, toolbarHeight);
		doneButtonLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
		doneButton.setLayoutParams(doneButtonLayoutParams);
		toolbar.addView(doneButton);
		doneButton.setOnTouchListener(buttonTouchListener);




		final NumberPicker numberPicker = new NumberPicker(context.getActivity().getApplicationContext());
		LinearLayout.LayoutParams pickerLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, Height-toolbarHeight);

		numberPicker.setLayoutParams(pickerLayoutParams);
		numberPicker.setY(toolbarHeight);
		numberPicker.setX(0);
		numberPicker.setDescendantFocusability(NumberPicker.FOCUS_BLOCK_DESCENDANTS);
		numberPicker.setBackgroundColor(Color.WHITE);
		setNumberPickerTextColor(numberPicker, Color.BLACK);
		numberPicker.setMinValue(0);
		numberPicker.setMaxValue(items.size()-1);
		numberPicker.setDisplayedValues(items.toArray(new String[0]));
		numberPicker.setWrapSelectorWheel(false);
		numberPicker.setValue(0);
		layout.addView(numberPicker);

		doneButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if(AirPickerExtensionContext.pickerControl != null) {
					ViewGroup rootContainer = finalContext.getActivity().findViewById(android.R.id.content);
					rootContainer = (ViewGroup) rootContainer.getChildAt(0);
					rootContainer.removeView(AirPickerExtensionContext.pickerControl);

				}
				String selectedValue = items.get(numberPicker.getValue());
				try {
					finalContext.dispatchStatusEventAsync("PICKER_SELECTED", selectedValue);
				} catch (Exception e) {
					Log.e("AirAlert", "error dispatching event", e);
				}
			}
		});

		layout.setX(posX);
		layout.setY(posY);
		AirPickerExtensionContext.pickerControl = layout;


		return null;

	}

	private static void setNumberPickerTextColor(NumberPicker numberPicker, int color){
		final int count = numberPicker.getChildCount();
		for (int i = 0; i < count; i++) {
			View child = numberPicker.getChildAt(i);
			if (child instanceof EditText) {
				try {
					((EditText) child).setTextColor(color);
					numberPicker.invalidate();
					Field selectorWheelPaintField = numberPicker.getClass().getDeclaredField("mSelectorWheelPaint");
					boolean accessible = selectorWheelPaintField.isAccessible();
					selectorWheelPaintField.setAccessible(true);
					((Paint) selectorWheelPaintField.get(numberPicker)).setColor(color);
					selectorWheelPaintField.setAccessible(accessible);
					numberPicker.invalidate();
				} catch (Exception exception) {
					Log.e("AirAlert", "setNumberPickerTextColor", exception);
				}
			}
		}
	}

}