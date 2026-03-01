package com.hogwarts.dao.admin;

import com.hogwarts.utils.Conexao;
import com.hogwarts.utils.Hash;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {
    public String ehAdmin(String email, String senha) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        return getLogin(email, senha, "SELECT NOME, SENHA FROM ADMINISTRADOR WHERE EMAIL = ?");
    }

    public String ehProfessor(String usuario, String senha) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        return getLogin(usuario, senha, "SELECT NOME, SENHA FROM PROFESSOR WHERE USUARIO = ?");
    }

    public String capturarDisciplina(String usuario, String nome) throws SQLException, ClassNotFoundException{
        String sql = "SELECT NOME FROM disciplina WHERE cod_professor = (SELECT ID FROM professor WHERE usuario = ? AND NOME = ?)";

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ){
            pstmt.setString(1, usuario);
            pstmt.setString(2, nome);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) return rs.getString("nome");
        } return null;
    }

    private String getLogin(String identificador, String senha, String sql) throws SQLException, NoSuchAlgorithmException, ClassNotFoundException {
        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ){
            pstmt.setString(1, identificador);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()){
                String senhaBanco = rs.getString("senha");
                String nome = rs.getString("nome");
                String hashSenha = Hash.hashSenha(senha);

                if (hashSenha.equals(senhaBanco)) return nome;
            } return null;
        }
    }
}
