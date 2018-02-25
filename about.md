<SCRIPT>
function passWord() {
var testV = 1;
var pass1 = prompt('Please Enter Your Password',' ');
while (testV < 3) {
if (!pass1) 
history.go(-1);
if (pass1.toLowerCase() == "letmein") {
alert('You Got it Right!');
window.open('www.wikihow.com');
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
<input type="button" value="Enter Protected Area" onClick="passWord()">
</FORM>
</CENTER>
     
TEST 1

<span style="color: #0362a5; font-family: Arial; font-size: 1.5em;">**About me**</span> <br />

![Picture1]({{ site.url }}/assests/pictures/family/About.jpg){:width="70%"}

My name is Nguyen Pham Quang Vu. I am a PhD student in Geotechnical Engineering at Yokohama National University.
This site was created to help you learn basic knowlege of Geotechnical Engineering and Finite Element Method




<span style="color: #0362a5; font-family: Arial; font-size: 1.2em;">**My bachelor school: Ho Chi Minh City University of Technology**</span> <br />
<div style="text-align:center;">
<iframe width="600" height = "400" src="https://www.youtube.com/embed/6bwXksy4Gxs" frameborder="0" allowfullscreen></iframe>
<div class="thecap">ホーチミン市工科大学紹介動画</div>
</div>
<br />

<span style="color: #0362a5; font-family: Arial; font-size: 1.2em;">**My graduate school: Yokohama National University**</span> <br />

<div style="text-align:center;">
<iframe width="600" height = "400" src="https://www.youtube.com/embed/NqMJVSZzdek" frameborder="0" allowfullscreen></iframe>
<div class="thecap">横浜国立大学紹介動画</div>
</div>


<span style="color: #0362a5; font-family: Arial; font-size: 1.5em;">**Contact Information**</span> <br />
<span style="color: #0362a5; font-family: Time News Roman; font-size: 1.0em;">
***Department of Civil Engineering, <br />
Yokohama National University***
</span>

**Mailing to:**<br />
240-8501 神奈川県横浜市保土ケ谷区常盤台79-5
建設学科土木工学棟 79 Tokiwadai, Hodogaya-ku, Yokohama-shi, Kanagawa-ken 240-0067

**Email:** <br />
quangvunp@gmail.com

**Office:**<br />
Room 207, S8-3 building, Civil Engineering Department, Yokohama National University

<form action="https://formspree.io/quangvunp@gmail.com"
     method="POST">
    <textarea placeholder = "Name" class="form-control" id="textarea" name="name" rows = "1" cols ="80"></textarea>
    <textarea placeholder = "Email" class="form-control" id="textarea" name="email" rows = "1" cols ="80"></textarea>
    <textarea placeholder = "Subject" class="form-control" id="textarea" name="subject" rows = "1" cols ="80"></textarea>
    <textarea placeholder = "Message" class="form-control" id="textarea" name="message" rows = "10" cols ="80"></textarea><br />
   <input type="submit" value="Send">
</form>
