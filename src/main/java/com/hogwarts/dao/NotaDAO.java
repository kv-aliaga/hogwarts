package com.hogwarts.dao;

import com.hogwarts.model.banco.Nota;
import com.hogwarts.utils.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class NotaDAO {
    public void inserirNota(double notaValor, Nota infoNota, boolean ehNotaUm) throws SQLException, ClassNotFoundException {
        String sql;

        if (ehNotaUm) sql = "UPDATE NOTA SET NOTA_UM = ? WHERE COD_ALUNO = ? AND COD_DISCIPLINA = ?";
        else sql = "UPDATE NOTA SET NOTA_DOIS = ? WHERE COD_ALUNO = ? AND COD_DISCIPLINA = ?";

        setarValores(notaValor, infoNota, sql);
    }

    public void atualizarNota(double notaValor, Nota infoNota, boolean ehNotaUm) throws SQLException, ClassNotFoundException{
        String sql;

        if (ehNotaUm){
            sql = "UPDATE NOTA SET NOTA_UM = ? WHERE COD_ALUNO = ? AND COD_DISCIPLINA = ?";
            setarValores(notaValor, infoNota, sql);
        }
        else inserirNota(notaValor, infoNota, false);
    }

    public void excluirNota(Nota n, boolean ehNotaUm) throws SQLException, ClassNotFoundException{
        String sql;
        if (ehNotaUm) sql = "UPDATE NOTA SET NOTA_UM = 0 WHERE COD_ALUNO = ? AND COD_DISCIPLINA = ?";
        else sql = "UPDATE NOTA SET NOTA_DOIS = 0 WHERE COD_ALUNO = ? AND COD_DISCIPLINA = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, n.getAluno().getMatricula());
            pstmt.setInt(2, n.getDisciplina().getId());
        }
    }

    private void setarValores(double notaValor, Nota infoNota, String sql) throws SQLException, ClassNotFoundException{
        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setDouble(1, notaValor);
            pstmt.setInt(2, infoNota.getAluno().getMatricula());
            pstmt.setInt(3, infoNota.getDisciplina().getId());
        }
    }
}
