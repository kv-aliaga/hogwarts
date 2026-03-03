package com.hogwarts.dao.admin;

import com.hogwarts.model.banco.CasaHogwarts;
import com.hogwarts.model.banco.Professor;
import com.hogwarts.utils.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CasaDAO {
//    Método de visualizar casas de Hogwarts
    public List<CasaHogwarts> buscarCasaHogwarts() throws SQLException, ClassNotFoundException{
        List<CasaHogwarts> casasHogwarts = new ArrayList<>();
        String sql = """
                SELECT c.ID, c.NOME, c.PONTUACAO, p.NOME as "PROFESSOR", p.ID as "PROF_ID"
                FROM CASA_HOGWARTS c
                LEFT JOIN PROFESSOR p ON p.id = c.COD_PROFESSOR
                """;

        try(Connection conn = Conexao.conectar();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql)){
            while (rs.next()){
                CasaHogwarts c = new CasaHogwarts();
                Professor p = new Professor();

                p.setNome(rs.getString("professor"));
                p.setId(rs.getInt("prof_id"));

                c.setId(rs.getInt("id"));
                c.setNome(rs.getString("nome"));
                c.setPontuacao(rs.getInt("pontuacao"));
                c.setProfessor(p);

                casasHogwarts.add(c);
            } return casasHogwarts;
        }
    }

//    Método de atualizar professor gestor da casa de hogwarts
    public void atualizarCasa(int idSubstituto, int idCasa) throws SQLException, ClassNotFoundException{
        String sql = "UPDATE CASA_HOGWARTS SET COD_PROFESSOR = ? WHERE ID = ?";
        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, idSubstituto);
            pstmt.setInt(2, idCasa);

            pstmt.executeUpdate();
        }
    }

    public void atualizarPontos(int pontuacao, int idCasa) throws SQLException, ClassNotFoundException{
        String sql = "UPDATE CASA_HOGWARTS SET PONTUACAO = ? WHERE ID = ?";
        try (Connection conn = Conexao.conectar();
        PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, pontuacao);
            pstmt.setInt(2, idCasa);

            pstmt.executeUpdate();
        }
    }
}
