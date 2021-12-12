[![N|Solid](https://i.imgur.com/eAIuo9U.png)](https://github.com/jmpessoa/lazandroidmodulewizard)

# GUI Design WYSIWYG
      (by "Ahmad Bohloolbandi" a.k.a. "developing")

### How to design a GUI layout that shown same in real device?

- For visual components onfigure these properties: 

	    Anchor 
		PosRelativeToParent 
		PosRelativeToAnchor 
		LayoutParamHeight
		LayoutParamWhidth 
          
- **Example** 

  - 1 -  Put a  **jTextView** component on LAMW Form and set properties:

	      PosRelativeToParent
		     rpCenterHorizontal = [True]
		     rpTop = [True]
		  Text = GUI Design WYSIWYG   
		     
		  (Because only Position Relative to Parent(form) is need to localize jTextView1)

  - 2 - Put a **jEditText** component on LAMW Form and set properties:

	      Anchor = jTextView1
	      LayoutParamWidth = lpTwoThirdOfParent
	      PosRelativeToAnchor
		     raBelow = [True]
	      PosRelativeToParent
		     rpCenterHorizontal = [True]
		  Text = Ok

		  (Because we want it to be bellow the jTextView1)
		     
  - 3 - Put a **jButton** component on LAMW Form and set properties:

	      Anchor = jEditText1
	      LayoutParamWidth = lpTwoThirdOfParent 
	      PosRelativeToAnchor
		     raBelow = [True]
	      PosRelativeToParent
		     rpCenterHorizontal = [True]
		  Text = Sample    

		  (Because we want it to be bellow the jEditText1)

  - 3 - Hint:
 
           To Change width/height of each visual components you should 
           configure LayoutParamWhidth and LayoutParamHeight!

### Others references...
##### [Tutorial: My First "Hello Word" App](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/AppHelloWorld.md)
##### [Multi-Form demo](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/demos/GUI/AppTest1)
##### [All LAMW GUI demos](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/demos/GUI)
