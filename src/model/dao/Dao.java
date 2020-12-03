package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.Asiakas;

public class Dao {
	private Connection con = null;
	private ResultSet rs =  null;
	private PreparedStatement stmtPrep = null;
	private String sql;
	private String db="Myynti.sqlite";
	
	private Connection yhdista() {
		Connection con = null;
		String path = System.getProperty("catalina.base");
		path = path.substring(0, path.indexOf(".metadata")).replace("\\", "/");
		String url = "jdbc:sqlite:"+path+db;
		try {
			Class.forName("org.sqlite.JDBC");
			con = DriverManager.getConnection(url);
			System.out.println("Yhteys avattu.");
		}catch (Exception e) {
			System.out.println("Yhteyden avaus epäonnistui");
			e.printStackTrace();
		}
		return con;
	} 
	
	public ArrayList<Asiakas> listaaKaikki(){
		ArrayList<Asiakas> asiakkaat = new ArrayList<Asiakas>();
		sql = "SELECT * FROM Asiakkaat";
		try {
			con=yhdista();
			if(con!=null) {
				System.out.println("toimii");
				stmtPrep = con.prepareStatement(sql);
				rs = stmtPrep.executeQuery();
				if(rs!=null) {
					while(rs.next()){
						Asiakas asiakas = new Asiakas();
						asiakas.setAsiakas_id(rs.getInt(1));
						asiakas.setEtunimi(rs.getString(2));
						asiakas.setSukunimi(rs.getString(3));
						asiakas.setPuhelin(rs.getString(4));
						asiakas.setSposti(rs.getString(5));
						asiakkaat.add(asiakas);
					}
				}
			}
			con.close();
			System.out.println("Yhteys suljettu");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return asiakkaat;
	}
	
	public ArrayList<Asiakas> listaaKaikki(String hakusana){
		ArrayList<Asiakas> asiakkaat = new ArrayList<Asiakas>();
		sql = "SELECT * FROM Asiakkaat WHERE etunimi LIKE ? or sukunimi LIKE ?";
		try {
			con=yhdista();
			if(con!=null) {
				System.out.println("toimii");
				stmtPrep = con.prepareStatement(sql);
				stmtPrep.setString(1, "%" + hakusana + "%");
				stmtPrep.setString(2, "%" + hakusana + "%");
				rs = stmtPrep.executeQuery();
				if(rs!=null) {
					while(rs.next()){
						Asiakas asiakas = new Asiakas();
						asiakas.setAsiakas_id(rs.getInt(1));
						asiakas.setEtunimi(rs.getString(2));
						asiakas.setSukunimi(rs.getString(3));
						asiakas.setPuhelin(rs.getString(4));
						asiakas.setSposti(rs.getString(5));
						asiakkaat.add(asiakas);
					}
				}
			}
			con.close();
			System.out.println("Yhteys suljettu");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return asiakkaat;
	}
	public boolean lisaaAsiakas(Asiakas asiakas) {
		boolean paluu=true;
		sql="INSERT INTO Asiakkaat(etunimi, sukunimi, puhelin, sposti) VALUES(?, ?, ?, ?)";
		try {
			con = yhdista();
			System.out.println("yhdistetty");
			stmtPrep=con.prepareStatement(sql);
			stmtPrep.setString(1, asiakas.getEtunimi());
			stmtPrep.setString(2, asiakas.getSukunimi());
			stmtPrep.setString(3, asiakas.getPuhelin());
			stmtPrep.setString(4, asiakas.getSposti());
			stmtPrep.executeUpdate();
			System.out.println(sql);
			con.close();
			System.out.println("Yhteys suljettu");
		} catch (Exception e) {
			e.printStackTrace();
			paluu=false;
		}
		return paluu;
	}
	
	public boolean poistaAsiakas(String poistettavaId) {
		boolean paluuArvo=true;
		sql="DELETE FROM Asiakkaat WHERE asiakas_id=?";
		int poistettavaInt = Integer.parseInt(poistettavaId);
		try {
			con = yhdista();
			System.out.println("poisto_yhdistetty "+poistettavaInt);
			stmtPrep=con.prepareStatement(sql);
			stmtPrep.setInt(1, poistettavaInt);
			stmtPrep.executeUpdate();
			System.out.println(sql);
			con.close();
			
		}catch (Exception e) {
			e.printStackTrace();
			paluuArvo=false;
		}
		System.out.println(paluuArvo);
		return paluuArvo;
	}
	
	public Asiakas etsiAsiakas(String asiakas_id) {
		Asiakas asiakas = null;
		sql = "SELECT * FROM Asiakkaat WHERE asiakas_id=?";
		int asiakasInt = Integer.parseInt(asiakas_id);
		try {
			con=yhdista();
			if(con !=null) {
				stmtPrep = con.prepareStatement(sql);
				stmtPrep.setInt(1, asiakasInt);
				rs = stmtPrep.executeQuery();
				if(rs.isBeforeFirst()) {
					rs.next();
					asiakas = new Asiakas();
					asiakas.setAsiakas_id(rs.getInt(1));
					asiakas.setEtunimi(rs.getString(2));
					asiakas.setSukunimi(rs.getString(3));
					asiakas.setPuhelin(rs.getString(4));
					asiakas.setSposti(rs.getString(5));
				}
			}
			con.close();
			System.out.println("Yhteys suljettu");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return asiakas;
		}
	
		public boolean muutaAsiakas(Asiakas asiakas, int asiakas_id) {
		boolean paluu=true;
		System.out.println(asiakas);
		sql="UPDATE Asiakkaat SET etunimi=?, sukunimi=?, puhelin=?, sposti=? WHERE asiakas_id=?";
		try {
			con = yhdista();
			System.out.println("yhdistetty-muutos");
			stmtPrep=con.prepareStatement(sql);
			stmtPrep.setString(1, asiakas.getEtunimi());
			stmtPrep.setString(2, asiakas.getSukunimi());
			stmtPrep.setString(3, asiakas.getPuhelin());
			stmtPrep.setString(4, asiakas.getSposti());
			stmtPrep.setInt(5, asiakas_id);
			stmtPrep.executeUpdate();
			System.out.println(sql);
			con.close();
			System.out.println("Muutos - Yhteys suljettu");
		} catch (Exception e) {
			e.printStackTrace();
			paluu=false;
		}
		return paluu;
	}
	


	
}
