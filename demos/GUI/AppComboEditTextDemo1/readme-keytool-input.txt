Tutorial: How to get your keystore to Apk release:

1. Edit "keytool_input.txt" to more representative information!"
2. You need answer the prompts:

Enter keystore password: 123456
Re-enter new password: 123456
What is your first and last name?
  [Unknown]:  MyFirstName MyLastName
What is the name of your organizational unit?
  [Unknown]:  MyDevelopmentUnit
What is the name of your organization?
  [Unknown]:  MyExampleCompany
What is the name of your City or Locality?
  [Unknown]:  MyCity
What is the name of your State or Province?
  [Unknown]:  AA
What is the two-letter country code for this unit?
  [Unknown]:  BB
Is <CN=MyFirstName MyLastName, OU=MyDevelopmentUnit, O=MyExampleCompany,
    L=MyCity, ST=AA, C=BB> correct?
  [no]:  y
Enter key password for <appcomboedittextdemo1aliaskey> <RETURN if same as keystore password>: 123456

3. Execute "release-keystore.bat" [.sh]
            warning: well, before execute, you can change/edit the [param] -alias appcomboedittextdemo1aliaskey
              ex.  -alias www.mycompany.com 
              Please, change/edit/Sync [key.alias=appcomboedittextdemo1aliaskey] "ant.properties" too!

4. Edit [notepad like] "ant.properties" to more representative information!"
        warning: "key.alias=appcomboedittextdemo1aliaskey" need be the same as in "release-keystore.bat [.sh]"

Yes, you got his [renowned] keystore!

....  Thank you!

....  by jmpessoa_hotmail_com
