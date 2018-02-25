---
layout: post
title:  "Password Protect"
date:   2018-02-25
tags: [Jekyll]
---

Đọc đường link sau sẽ biết rõ cách làm:

[link](https://www.wikihow.com/Password-Protect-a-Web-Page)


<SCRIPT>
function passWord() {
var testV = 1;
var pass1 = prompt('Please Enter Your Password',' ');
while (testV < 3) {
if (!pass1) 
history.go(-1);
if (pass1.toLowerCase() == "letmein") {
alert('Welcome to my note!');
window.open('https://quangvunp.github.io/geomechanics/assests/Notes/FEM/FDM_1D.PDF');
break;
} 
testV+=1;
var pass1 = 
prompt('Access Denied - Password Incorrect, Please Try Again.','Password');
}
if (pass1.toLowerCase()!="password" & testV ==3) 
history.go(-1);
return " ";
} 
</SCRIPT>
<CENTER>
<FORM>
<input type="link" value="FEM lecture 1" onClick="passWord()">
</FORM>
</CENTER>
     
