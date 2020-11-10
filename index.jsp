<%--
  Created by IntelliJ IDEA.
--%>
<%--<jsp:useBean id="JustBean" class="JustBean"></jsp:useBean>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="ru" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <title>Lab №2</title>
    <link rel="stylesheet" href="main.css" type="text/css">
    <script type="text/javascript" src="jquery-3.4.1.min.js"></script>

</head>
<script>
    let working = false;
    let x = 0;
    let y = 0;
    let isSay_x = false;
    let isSay_y = false;

    function valX() {
        document.getElementById("messagex").innerHTML="<br>";
        let choose = false;
        $('#selectX option').each(function () {
            if($(this).is(':selected')){
                choose =true;
                x = Number($(this).val());
            }
        });
        if (!choose){
            document.getElementById("messagex").innerHTML="Please choose X";
        }
        if (!validateR()){
            return false;
        }
        return choose
    }

    function valY() {
        document.getElementById("messagey").innerHTML="<br>";
        let choose = true;
        let countY = document.forms['form'].elements['texty'].value.trim();
        if (countY === ""){
            document.getElementById("messagey").innerHTML = "Please enter Y";
            choose = false;
        }else {
            if (!/^(-?\d+)([.,]\d+)?$/.test(countY)) {
                document.getElementById("messagey").innerHTML = "Incorrect input";
                choose = false;
            } else if (countY <= -3 | countY >= 3) {
                document.getElementById("messagey").innerHTML = "Y not in the range";
                choose = false;
            }
        }
        if (!validateR()){
            return false;
        }

        if (choose){
            y = Number($("#texty").text().trim());
        }
        return choose;
    }

</script>
<br>
<header id="title" >
    <p>Lab work №2.
        Student: Mashkovcev Alexander
        Group: P3213
        Variant: 214829</p>
</header>
<button id="justbutton" name="justbutton" onclick="showDisplay()" type="button">Start</button>
</p>
<table align="right">
    <tr>
        <td width="20%" class="picture">
            <table>
                <tr>
                    <td>
                        <canvas width="300" height="300" id="area" ></canvas>
                    </td>
                    <td id="description_area">
                        <div id="circle_pink"></div>
                        <p class="color_description">  Hit</p>
                        <br><br>
                        <div id="circle_black"></div>
                        <p class="color_description">  Miss</p>
                        <br><br>
                    </td>
                </tr>
            </table>
            <h2 id="validArea">Valid area</h2>

        </td>
        <td width="80%">
        </td>
    </tr>
</table>
<br>
<table>
    <tr id="enterPlace">
        <form id="form" name="form" method="post">
            <td id="X" width="100pt">
                <h2 id="enterx">
                    Enter X:
                </h2>
                <select id="selectX" name="selectX">
                    <option id="radiox-4" name="radiox" type="radio" value="-5">-5</option>
                    <option id="radiox-3" name="radiox" type="radio" value="-4">-4</option>
                    <option id="radiox-2" name="radiox" type="radio" value="-3">-3</option>
                    <option id="radiox-1" name="radiox" type="radio" value="-2">-2</option>
                    <option id="radiox0" name="radiox" type="radio" selected value="-1">-1</option>
                    <option id="radiox1" name="radiox" type="radio" value="0">0</option>
                    <option id="radiox2" name="radiox" type="radio" value="1">1</option>
                    <option id="radiox3" name="radiox" type="radio" value="2">2</option>
                    <option id="radiox4" name="radiox" type="radio" value="3">3</option>
                </select>
                <p id="messagex" ><br></p>
            </td>
            <td id="Y" width="300pt">
                <h2 id="entery" >
                    Enter Y in the range (-3;3):
                </h2>
                <input name="texty" id="texty" type="text" maxlength="8" />
                <p id="messagey"><br></p>

            </td>
            <td id="R" width="100pt">
                <h2 id="enterr">
                    Enter R:
                </h2>
                <label for="r1">1</label><input id="r1" name="r" type="radio" value="1" /><br>
                <label for="r2">2</label><input id="r2" name="r" type="radio" value="2" /><br>
                <label for="r3">3</label><input id="r3" name="r" type="radio" value="3" /><br>
                <label for="r4">4</label><input id="r4" name="r" type="radio" value="4" /><br>
                <label for="r5">5</label><input id="r5" name="r" type="radio" value="5" /><br>
                <p id="messager"><br></p>
            </td>
            <td width=" 500pt" id="SubButton">
                <p id="buttons">
                    <button id="suputton" name="suputton" type="submit">Submit</button>
                </p>
            </td>
        </form>
    </tr>
</table>
</br></br></br></br>
<div id="result_content">
    <div id="result"></div>
</div>
</body>
</html>
<script>
    let have_count = false;
    let plot = document.getElementById("area");
    let context = plot.getContext('2d');
    plot.addEventListener("click",changeDot,false);
    let identification = ["#title","#info",".picture","#design","#enterPlace","#X","#Y","#R","#SubButton"];
    let flagX = false;
    function showDisplay() {
        for (let i = 0; i < 9; i++) {
            $(identification[i]).fadeIn(5000);
        }
        $("#but").css('display','none');
        $("#justbutton").css('display','none');

    }

    $('input[name=r]').change(function () {
        let dt = false;
        for (let i=1;i<6;i++){
            if (document.getElementById("r"+i).checked){
                dt=true;
            }
        }
        if(dt) {
            radius = $(this).val();
            paint(radius * 25);
            if (have_count)
                console.log("changed");
            points();
        }
    });

    function points() {
        have_count = true;
        let rows = $('#result_count').find('tr');
        let numb = rows.length;
        for (let i =1 ; i<numb;i++){
            let tdSet = $(rows[i]).find('td');
            r = Number($(tdSet[2]).text().trim());
            R = Number($('input[name=r]:checked').val());
            xx = Number($(tdSet[0]).text().trim());
            yy = Number($(tdSet[1]).text().trim());
            if(r == R) {
                if ($(tdSet[3]).text().trim() == 'true') {
                    context.fillStyle = 'pink';
                    console.log(true);
                    console.log('X:'+ xx +'Y:'+ yy +'R:'+R+' - hit(pink)');
                } else {
                    context.fillStyle = "#2A2A2A";
                    console.log(false);
                    console.log('X:'+xx+'Y:'+yy+'R:'+R+' - miss(grey)');
                }
            } else {
                if (validate(xx,yy,R)){
                    context.fillStyle = 'pink';
                    console.log(true);
                    console.log('X:'+ xx +'Y:'+ yy +'R:'+R+' - hit(pink)');
                }else {
                    context.fillStyle = "#2A2A2A";
                    console.log(false);
                    console.log('X:' + xx + 'Y:' + yy + 'R:' + R + ' - miss(grey)');
                }
            }
            paintPoint(xx, yy);
        }

    }

    function validate(x, y, r) {
        let inArea = false;
        console.log("X:"+x+"  Y:" + y + "  R:" + r);
        if (x < 0 && y > 0 ){
            inArea = false;
            return inArea;
        }
        if (x > 0 && y < 0 && x < r/2 && -y < r/2){
            if((x*x)+(y*y)<r*r) {
                inArea = true;
            }
            else inArea = false;
            return inArea;
        }
        if (x == 0 && y == 0){
            inArea = false;
            return inArea;
        }
        if(x < 0 && y < 0){
            if((-x < r) && (-y < r)) {
                inArea = true;
            }
            else inArea = false;
            return inArea;
        }
        if(x>0 && y>0){
            if (Math.sqrt((x*x) + (y*y)) <=r){
                inArea = true;
            }
            else inArea = false;
            return inArea;
        }
        inArea = false;
        return inArea;
    }

    function changeDot(e) {
        let x;
        let y;
        let r;
        if (validateR()){
            x = e.offsetX;
            y = e.offsetY;
            x = (x-150)/25;
            y=-(y-150)/25;
            r = $('input[name=r]:checked').val();
            $.ajax({
                type:'POST',
                url:"controller",
                data:{selectX:x,texty:y,r:r},
                response:'text',
                error: function (message) {
                    console.log(message);
                    $('#result').text(message);
                    alert("Error " + message);
                },
                success: function (msg) {
                    $('#result').html(msg);
                    points();
                }}
            )
        }
    }
    function paintPoint(x,y){
        let X = x*25+150;
        let Y = -y*25 + 150;
        context.beginPath();
        context.arc(X,Y,3,0,Math.PI*2,false);
        context.closePath();
        context.fill();
    }



    function validateR() {
        document.getElementById("messager").innerHTML="<br>";
        for (let i=1;i<6;i++){
            if (document.getElementById("r"+i).checked){
                return true;
            }
        }
        document.getElementById("messager").innerHTML="Please choose R";
        return false;
    }

    function validateXY() {
        document.getElementById("messagex").innerHTML="<br>";
        document.getElementById("messagey").innerHTML="<br>";
        let choose = false;
        $('#selectX option').each(function () {
            if($(this).is(':selected')){
                choose =true;
            }
        });
        if (!choose){
            document.getElementById("messagex").innerHTML="Please choose X";
        }
        let countY = document.forms['form'].elements['texty'].value.trim();
        if (countY === ""){
            document.getElementById("messagey").innerHTML = "Please enter Y";
            choose = false;
        }else {
            if (!/^(-?\d+)([.,]\d+)?$/.test(countY)) {
                document.getElementById("messagey").innerHTML = "Incorrect input";
                choose = false;
            } else if (countY <= -3 | countY >= 3) {
                document.getElementById("messagey").innerHTML = "Y not in the range";
                choose = false;
                console.log(choose);
            }
        }
        if (!validateR()){
            return false;
        }
        return choose
    }

    function paint(R) {
        // context.fillStyle = "#fff"
        context.fillStyle = "rgba(255,255,255,1)"

        context.fillRect(0,0,300,300);

        context.fillStyle="#6c4480";
        context.fillRect(150.5-R,150.5,R,R);
        context.beginPath();
        context.arc(150.5,150.5,R,0,Math.PI*1.5,true);
        context.lineTo(150.5,150.5);
        context.closePath();
        context.fill();
        context.beginPath();
        context.moveTo(150,150);
        context.lineTo(150+R/2,150);
        context.lineTo(150,150+R/2);
        context.closePath();
        context.fill();

        // context.fillStyle = "#fff";
        // context.stroke = "#fff";
        context.beginPath();
        context.moveTo(150,300);
        context.lineTo(150,0);
        context.moveTo(145,10);
        context.lineTo(150,0);
        context.lineTo(155,10);

        context.moveTo(0,150);
        context.lineTo(300,150);
        context.moveTo(290,145);
        context.lineTo(300,150);
        context.lineTo(290,155);
        for (let i=25; i<=275;i+=12.5){
            context.moveTo(i,145);
            context.lineTo(i,155);
            context.moveTo(145,i);
            context.lineTo(155,i);
        }
        for (let j=25;j<=275;j+=25){
            context.moveTo(j,143);
            context.lineTo(j,157);
            context.moveTo(143,j);
            context.lineTo(157,j);
        }
        context.stroke();
        context.font = " bold 16px Arial black";
        context.fillText("x",290,170);
        context.fillText("y",160,10);
    }

    $(function () {
        paint(0);
    });

    $('#form').submit(function () {
        let flag = Boolean(validateXY());
        if(flag) {
            $.ajax({
                type:'POST',
                url:"controller",
                data:$('#form').serialize(),
                response:'text',
                error:function (msg) {
                    console.log(msg);
                    $('#results').text(msg);
                    alert("Error " + msg);
                },
                success:function (msg) {
                    $('#result').html(msg);

                    points();
                }}
            )
        }
        return false;
    });

    $("#justbutton").fadeIn(3000);
    $("#start").fadeIn(3000);
</script>
