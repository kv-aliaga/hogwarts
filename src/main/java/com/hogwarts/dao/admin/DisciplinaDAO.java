package com.hogwarts.dao.admin;

import com.hogwarts.model.banco.Disciplina;
import com.hogwarts.model.banco.Professor;
import com.hogwarts.utils.Conexao;
import com.hogwarts.utils.Hash;

import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DisciplinaDAO {
//    Vincular disciplinas a alunos
    public void vincularAlunos(int idDisc) throws SQLException, ClassNotFoundException{
        String sqlSelect = "SELECT matricula FROM aluno ORDER BY 1";
        String sqlInsert = "INSERT INTO nota (cod_aluno, cod_disciplina, nota_um, nota_dois) VALUES (?, ?, ?, ?)";

        try(Connection conn = Conexao.conectar();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sqlSelect);

            PreparedStatement pstmt = conn.prepareStatement(sqlInsert)){
            while (rs.next()){
                pstmt.setInt(1, rs.getInt("matricula"));
                pstmt.setInt(2, idDisc);
                pstmt.setDouble(3, 0.0);
                pstmt.setDouble(4, 0.0);

                pstmt.executeUpdate();
            }
        }
    }

//    Método de inserir disciplina
    public void inserirDisciplina(Disciplina disciplina) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO disciplina (NOME, COD_PROFESSOR) VALUES (?, ?) RETURNING ID";

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, disciplina.getNome());
            pstmt.setInt(2, disciplina.getProfessor().getId());

            try (ResultSet rs = pstmt.executeQuery()){
                if (rs.next()){
                    vincularAlunos(rs.getInt("id"));
                }
            }
        }
    }

//    Método de atualizar disciplina do professor
    public void atualizarDisciplina(int idDisciplina, int idProfNovo) throws SQLException, ClassNotFoundException{
        String sql = """
                DELETE FROM observacao WHERE cod_disciplina = ?;
                UPDATE disciplina SET cod_professor = ? WHERE id = ?;
                """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ){
            pstmt.setInt(1, idDisciplina);
            pstmt.setInt(2, idProfNovo);
            pstmt.setInt(3, idDisciplina);

            pstmt.executeUpdate();
        }
    }

//    Método de inserir professor
    public void inserirProfessor(Professor professor) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        String sql = "INSERT INTO professor (NOME, USUARIO, SENHA) VALUES (?, ?, ?)";

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ){
            pstmt.setString(1, professor.getNome());
            pstmt.setString(2, professor.getUsuario());
            pstmt.setString(3, Hash.hashSenha(professor.getSenha()));

            pstmt.executeUpdate();
        }
    }

//    Método de visualizar professores
    public List<Disciplina> buscarProfessores() throws SQLException, ClassNotFoundException {
        List<Disciplina> professores = new ArrayList<>();
        String sql = """
                     SELECT p.ID, p.NOME, p.USUARIO, d.id as "cod_disciplina", d.NOME as "DISCIPLINA"
                     FROM professor p
                     FULL JOIN disciplina d ON d.cod_professor = p.id
                     """;

        try (Connection conn = Conexao.conectar();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)
        ){
            while (rs.next()){
                Professor p = new Professor();
                Disciplina d = new Disciplina();

                d.setId(rs.getInt("cod_disciplina"));
                d.setNome(rs.getString("disciplina"));

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("nome"));
                p.setUsuario(rs.getString("usuario"));
                d.setProfessor(p);

                professores.add(d);
            } return professores;
        }
    }

//    Método de visualizar outras disciplinas de um professor
    public List<String> buscarOutrasDisciplinas(String disciplina) throws SQLException, ClassNotFoundException{
        List<String> disciplinas = new ArrayList<>();
        String sql = """
                SELECT nome FROM DISCIPLINA WHERE COD_PROFESSOR = (SELECT COD_PROFESSOR FROM DISCIPLINA WHERE NOME = ?)
                """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setString(1, disciplina);

            try (ResultSet rs = pstmt.executeQuery()){
                while (rs.next()){
                    disciplinas.add(rs.getString(1));
                } return disciplinas;
            }
        }
    }

//    Método de excluir professores
    public void excluirProfessor(int idProfessor) throws SQLException, ClassNotFoundException{
        String sql = """
                      DELETE FROM observacao
                      WHERE cod_disciplina = (SELECT id FROM disciplina WHERE cod_professor = ?);
                      
                      UPDATE disciplina
                      SET cod_professor = NULL
                      WHERE cod_professor = ?;
                      
                      UPDATE casa_hogwarts
                      SET cod_professor = NULL
                      WHERE cod_professor = ?;
                     
                      DELETE FROM professor
                      WHERE id = ?
                      """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, idProfessor);
            pstmt.setInt(2, idProfessor);
            pstmt.setInt(3, idProfessor);
            pstmt.setInt(4, idProfessor);

            pstmt.executeUpdate();
        }
    }

}
