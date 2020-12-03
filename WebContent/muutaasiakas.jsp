<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<title>Asiakkaat-muutos</title>
<style>
table {border-collapse: collapse;}

thead {color: blue;
	background-color:#8cfaf6;
	text-align: left;
	padding: 5}

tbody {
  border: 1px solid black;
  padding: 15px;

}


button {
  padding: 10px;
  text-align: center;
  display: inline-block;
  font-size: 14px;
  cursor: pointer;
  }
</style>
</head>
<body>
	<form id="tiedot">
		<table>
			<thead>
				<tr>
					<th colspan="5"><h2>Muuta asiakkaan tiedot</h2></th>
				</tr>
				<tr>
					<th>Etunimi:</th>
					<th>Sukunimi:</th>
					<th>Puhelin:</th>
					<th>Sähköposti:</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input type="text" name="etunimi" id="etunimi"></td>
					<td><input type="text" name="sukunimi" id="sukunimi"></td>
					<td><input type="text" name="puhelin" id="puhelin"></td>
					<td><input type="text" name="sposti" id="sposti"></td>	
					<td><input type="submit" id="tallenna" value="Muuta"></td>
					<td><input type="hidden" name="asiakas_id" id="asiakas_id"></td>
			</tbody>
		</table>
		
	</form>
	<div>
		<h4 id='ilmo'> </h4> 
		<button id="takaisin">Takaisin listaukseen</button>
	</div>
</body>
<script>
$(document).ready(function() {
	$("#takaisin").click(function(){
		document.location="listaaAsiakkaat.jsp";
	});
	
	var haku = requestURLParam("asiakas_id");
	console.log(haku);
	
	$.ajax({url:"Asiakkaat/haeyksi/"+haku, type:"GET", dataType:"json", success:function(result) {
			$("#asiakas_id").val(result.asiakas_id);
			$("#etunimi").val(result.etunimi);
			$("#sukunimi").val(result.sukunimi);
			$("#puhelin").val(result.puhelin);
			$("#sposti").val(result.sposti);
	}});
	
	$("#tiedot").validate({
		rules: {
			etunimi: {
				required: true,
				minlength: 1
			},
			sukunimi: {
				required: true,
				minlength: 1
			},
			puhelin: {
			
				minlength: 5
			},
			sposti: {
				required: true,
				email: true
			}
		},
		messages: {
			etunimi: {
				required: "Lisää etunimi",
				minlength: "Lisää etunimi"
			},
			sukunimi: {
				required: "Lisää sukunimi",
				minlength: "Lisää sukunimi"
			},
			puhelin: {
				required: "Lisää puh.nro",
				minlength: "Numeron on oltava vähintään 5 merkkiä"
			},
			sposti: {
				required: "Lisää sähköposti",
				email: "Sähköposti virheellinen"
			}
		},
		submitHandler: function(form) {
			muutaTiedot();
		}
	});
	$("#etunimi").focus(); 
});

function muutaTiedot(){
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray());
	console.log(formJsonStr);
	$.ajax({url:"Asiakkaat", data:formJsonStr, type:"PUT", dataType:"json", success:function(result){
		
		if(result.response==0){
			$("#ilmo").html("Asiakkaan päivittäminen epäonnistui.");
		}else if(result.response==1){
			$("#ilmo").html("Asiakkaan tiedot muutettu");
			$("#asiakas_id", "#etunimi", "#sukunimi", "#puhelin", "#sposti").val("")
		}
	}});
}
</script>

</html>