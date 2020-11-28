<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>Asiakkaat</title>
<style>
thead {color: blue;
	background-color:#8cfaf6;
	border:1;
	padding: 5}

table, th, td {
  border: 1px solid black;
  padding: 15px;
  text-align: center;
  border-collapse: collapse;
}
table tbody tr:hover {background-color: #f5f5f5;}

button {
	cursor: pointer;
	}
.poista {
	background-color: #eb4034;
	color: #ffffff;
	cursor: pointer;}
.lisaa {
	padding: 20px;
}
.lisaanappi {
  padding: 10px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 12px;
  }
	
	
</style>

</head>
<body>
<table id="lista" >
	<thead>
		<tr>
			<th colspan="6"><h1>Asiakkaat</h1><button class='lisaanappi' id="uusiAsiakas">Lisää uusi</button></th>
		</tr>
		<tr>
			<th colspan="2">Hakusana:</th>
			<th colspan="3"><input type="text" id="hakusana"></th>
			<th><button id="hakunappi">Hae</button></th>
		</tr>
		<tr>
			<th>ID</th>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelin</th>
			<th>e-mail</th>
			<th></th>
		</tr>
	</thead>
	<tbody >
	</tbody>
</table>


<script>
$(document).ready(function(){
	
	$("#uusiAsiakas").click(function() {
		document.location="lisaaasiakas.jsp";
	});
	
	haeAsiakkaat();
	
	$("#hakunappi").click(function() {
		console.log($("#hakusana").val());
		haeAsiakkaat();
	});
	$(document.body).on("keydown", function(event){
		if(event.which==13){
			haeAsiakkaat();
		}
	});
	$("#hakusana").focus();
});	

function haeAsiakkaat() {
	$("#lista tbody").empty();
	$.ajax({url:"Asiakkaat/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){
		console.log(result);
		$.each(result.asiakkaat, function(i, field){
			var htmlStr;
			htmlStr+="<tr>";
			htmlStr+="<td>"+field.asiakas_id+"</td>";
			htmlStr+="<td>"+field.etunimi+"</td>";
			htmlStr+="<td>"+field.sukunimi+"</td>";
			htmlStr+="<td>"+field.puhelin+"</td>";
			htmlStr+="<td>"+field.sposti+"</td>";
			htmlStr+="<td><button class='poista' onclick=poista('"+field.asiakas_id+"')>Poista</button></td>";
			$("#lista tbody").append(htmlStr);
		});
	}});
}

function poista(asiakas_id){
	console.log(asiakas_id);
	if(confirm("Haluatko poistaa asiakaan nr. " + asiakas_id +" tiedot?")){
		$.ajax({url:"Asiakkaat/"+asiakas_id, type:"DELETE", dataType:"json", success:function(result) { 
			console.log(result);
	        if(result.response==0){
	        	$("#ilmo").html("Asiakkaan poisto epäonnistui.");
	        }else if(result.response==1){
	        	alert("Asiakas nr. " + asiakas_id +" poistettu");
				haeAsiakkaat();        	
			}
	    }});
	}
}

</script>
</body>
</html>