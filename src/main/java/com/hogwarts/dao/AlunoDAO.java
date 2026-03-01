package com.hogwarts.dao;

import com.hogwarts.model.*;
import com.hogwarts.model.banco.*;
import com.hogwarts.utils.Conexao;
import com.hogwarts.utils.Hash;

import java.security.NoSuchAlgorithmException;
import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class AlunoDAO {
//    Método de inserir aluno em todas as disciplinas
    public void vincularDisciplinas(int matriculaAluno) throws SQLException, ClassNotFoundException{
        String sqlSelect = "SELECT id FROM disciplina ORDER BY 1";
        String sqlInsert = "INSERT INTO nota (cod_aluno, cod_disciplina, nota_um, nota_dois) VALUES (?, ?, ?, ?)";

        try(Connection conn = Conexao.conectar();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sqlSelect);

        PreparedStatement pstmt = conn.prepareStatement(sqlInsert)){
            while (rs.next()){
                pstmt.setInt(1, matriculaAluno);
                pstmt.setInt(2, rs.getInt("id"));
                pstmt.setDouble(3, 0.0);
                pstmt.setDouble(4, 0.0);

                pstmt.executeUpdate();
            }
        }
    }

//    Método de inserir aluno
    public void inserirAluno(Aluno aluno) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        String sql = "INSERT INTO aluno (NOME, CPF, EMAIL, SENHA, COD_CASA) VALUES (?, ?, ?, ?, ?) RETURNING matricula;";

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)
        ){
            pstmt.setString(1, aluno.getNome());
            pstmt.setString(2, aluno.getCpf());
            pstmt.setString(3, aluno.getEmail());
            pstmt.setString(4, Hash.hashSenha(aluno.getSenha()));
            pstmt.setInt(5, aluno.getCasaHogwarts().getId());

            try (ResultSet rs = pstmt.executeQuery()){
                if (rs.next()){
                    vincularDisciplinas(rs.getInt("matricula"));
                }
            }
        }
    }

//    Método de atualizar alunos
    public void atualizarAluno(Aluno aluno) throws SQLException, ClassNotFoundException{
        String sql = "UPDATE ALUNO SET EMAIL = ? WHERE MATRICULA = ?";
        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setString(1, aluno.getEmail());
            pstmt.setInt(2, aluno.getMatricula());
        }
    }

//    Método de excluir alunos
    public void excluirAluno(int matricula) throws SQLException, ClassNotFoundException{
        String sql = """
                      DELETE FROM nota WHERE cod_aluno = ?;
                      DELETE FROM observacao WHERE cod_aluno = ?;
                      DELETE FROM aluno WHERE matricula = ?;
                     """;
        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, matricula);
            pstmt.setInt(2, matricula);
            pstmt.setInt(3, matricula);
        }
    }

//    Método de buscar todos os alunos
    public List<Aluno> buscarAlunos() throws SQLException, ClassNotFoundException{
        List<Aluno> alunos = new ArrayList<>();
        String sql = """
                SELECT a.matricula, a.nome as "aluno", a.cpf, a.email, c.nome as "casa_hogwarts"
                FROM aluno a
                JOIN casa_hogwarts c ON c.id = a.cod_casa
                ORDER BY a.matricula;
                """;

        try(Connection conn = Conexao.conectar();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql)){
            while (rs.next()){
                Aluno a = new Aluno();
                CasaHogwarts c = new CasaHogwarts();

                c.setNome(rs.getString("casa_hogwarts"));

                a.setMatricula(rs.getInt("matricula"));
                a.setNome(rs.getString("aluno"));
                a.setCpf(rs.getString("cpf"));
                a.setEmail(rs.getString("email"));
                a.setCasaHogwarts(c);

                alunos.add(a);
            } return alunos;
        }
    }

//    Método de buscar um alunos
    public Aluno buscarAluno(String email, String senha) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        String sql = """
                SELECT a.matricula, a.nome as "aluno", a.cpf, a.email, c.nome as "casa_hogwarts"
                FROM aluno a
                JOIN casa_hogwarts c ON c.id = a.cod_casa
                WHERE email = ? AND senha = ?;
                """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            pstmt.setString(2, Hash.hashSenha(senha));

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Aluno a = new Aluno();
                    CasaHogwarts c = new CasaHogwarts();

                    c.setNome(rs.getString("casa_hogwarts"));

                    a.setMatricula(rs.getInt("matricula"));
                    a.setNome(rs.getString("aluno"));
                    a.setCpf(rs.getString("cpf"));
                    a.setEmail(rs.getString("email"));
                    a.setCasaHogwarts(c);

                    return a;
                }
            }
        } return null;
    }

//    Método de buscar um alunos
    public Aluno buscarAluno(int matricula) throws SQLException, ClassNotFoundException {
        String sql = """
                SELECT a.matricula, a.nome as "aluno", a.cpf, a.email, c.nome as "casa_hogwarts"
                FROM aluno a
                JOIN casa_hogwarts c ON c.id = a.cod_casa
                WHERE matricula = ?;
                """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, matricula);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Aluno a = new Aluno();
                    CasaHogwarts c = new CasaHogwarts();

                    c.setNome(rs.getString("casa_hogwarts"));

                    a.setMatricula(rs.getInt("matricula"));
                    a.setNome(rs.getString("aluno"));
                    a.setCpf(rs.getString("cpf"));
                    a.setEmail(rs.getString("email"));
                    a.setCasaHogwarts(c);

                    return a;
                }
            }
        } return null;
    }

//    Método de geração de boletim de um aluno para os professores
    public Boletim gerarBoletimIndividual(int matricula, String disc){
        // Criando atributos
        String sql = """
                SELECT a.nome as "aluno", a.email, a.matricula, d.nome as "disciplina", d.id, n.nota_um, n.nota_dois, o.observacao, o.id as "ob_id", p.nome as "professor", c.nome as "casa_hogwarts"
                FROM aluno a
                JOIN casa_hogwarts c ON a.cod_casa = c.id
                JOIN disciplina d ON d.id IN (SELECT cod_disciplina FROM nota WHERE cod_aluno = a.matricula)
                LEFT JOIN nota n ON n.cod_aluno = a.matricula AND n.cod_disciplina = d.id
                JOIN professor p ON p.id = d.cod_professor
                LEFT JOIN observacao o ON o.cod_aluno = a.matricula AND d.id = o.cod_disciplina
                WHERE a.matricula = ? AND d.id = (SELECT ID FROM disciplina WHERE NOME = ?)
                ORDER BY a.nome;
                """;

        // Realizando busca no banco de dados-
        try ( Connection conn = Conexao.conectar();
              PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            // Inserindo os atributos e recebendo o SELECT
            pstmt.setInt(1, matricula);
            pstmt.setString(2, disc);
            ResultSet rs = pstmt.executeQuery();

            // Inserindo os valores nos objetos
            if (rs.next()){
                Disciplina d = new Disciplina();
                Nota n = new Nota();
                Observacao o = new Observacao();
                Aluno a = new Aluno();
                Professor p = new Professor();
                CasaHogwarts c = new CasaHogwarts();

                // Capturando valores da seleção
                d.setNome(rs.getString("disciplina"));
                d.setId(rs.getInt("id"));

                n.setNotaUm(rs.getDouble("nota_um"));
                n.setNotaDois(rs.getDouble("nota_dois"));

                o.setObservacao(rs.getString("observacao"));
                o.setId(rs.getInt("ob_id"));

                a.setNome(rs.getString("aluno"));
                a.setEmail(rs.getString("email"));
                a.setMatricula(rs.getInt("matricula"));

                p.setNome(rs.getString("professor"));

                c.setNome(rs.getString("casa_hogwarts"));

                // Geração do boletim
                return new Boletim(a, n.getNotaUm(), n.getNotaDois(), o, d, p, c);
            }
        } catch (SQLException | ClassNotFoundException e){
            e.printStackTrace();
        } return null;
    }

//    Método de geração de boletim de um aluno para os alunos
    public List<Boletim> gerarBoletimIndividual(int matricula) throws SQLException, ClassNotFoundException {
        // Criando atributos
        List<Boletim> boletins = new ArrayList<>();
        String sql = """
                SELECT a.nome as "aluno", a.email, a.matricula, d.nome as "disciplina", d.id, n.nota_um, n.nota_dois, o.observacao, o.id as "ob_id", p.nome as "professor", c.nome as "casa_hogwarts"
                FROM aluno a
                JOIN casa_hogwarts c ON a.cod_casa = c.id
                JOIN disciplina d ON d.id IN (SELECT cod_disciplina FROM nota WHERE cod_aluno = a.matricula)
                LEFT JOIN nota n ON n.cod_aluno = a.matricula AND n.cod_disciplina = d.id
                JOIN professor p ON p.id = d.cod_professor
                LEFT JOIN observacao o ON o.cod_aluno = a.matricula AND d.id = o.cod_disciplina
                WHERE a.matricula = ?
                ORDER BY a.nome;
                """;

        // Realizando busca no banco de dados-
        try ( Connection conn = Conexao.conectar();
              PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            // Inserindo os atributos e recebendo o SELECT
            pstmt.setInt(1, matricula);

            try (ResultSet rs = pstmt.executeQuery()){
                // Inserindo os valores nos objetos
                while (rs.next()) {
                    Disciplina d = new Disciplina();
                    Nota n = new Nota();
                    Observacao o = new Observacao();
                    Aluno a = new Aluno();
                    Professor p = new Professor();
                    CasaHogwarts c = new CasaHogwarts();

                    // Capturando valores da seleção
                    d.setNome(rs.getString("disciplina"));
                    d.setId(rs.getInt("id"));

                    n.setNotaUm(rs.getDouble("nota_um"));
                    n.setNotaDois(rs.getDouble("nota_dois"));

                    o.setObservacao(rs.getString("observacao"));
                    o.setId(rs.getInt("ob_id"));

                    a.setNome(rs.getString("aluno"));
                    a.setEmail(rs.getString("email"));
                    a.setMatricula(rs.getInt("matricula"));

                    p.setNome(rs.getString("professor"));

                    c.setNome(rs.getString("casa_hogwarts"));

                    // Geração do boletim
                    boletins.add(new Boletim(a, n.getNotaUm(), n.getNotaDois(), o, d, p, c));
                } return boletins;
            }
        }
    }

//    Método de geração de boletim de todos os alunos
    public List<Boletim> gerarBoletimTodos(){
        // Criando atributos
        List<Boletim> boletins = new ArrayList<>();
        String sql = """
                SELECT a.nome as "aluno", a.email, a.matricula, d.nome as "disciplina", d.id, n.nota_um, n.nota_dois, o.observacao, o.id as "ob_id", p.nome as "professor", c.nome as "casa_hogwarts"
                FROM aluno a
                JOIN casa_hogwarts c ON a.cod_casa = c.id
                JOIN disciplina d ON d.id IN (SELECT cod_disciplina FROM nota WHERE cod_aluno = a.matricula)
                LEFT JOIN nota n ON n.cod_aluno = a.matricula AND n.cod_disciplina = d.id
                JOIN professor p ON p.id = d.cod_professor
                LEFT JOIN observacao o ON o.cod_aluno = a.matricula AND d.id = o.cod_disciplina
                ORDER BY a.nome;""";

        // Realizando busca no banco de dados
        try ( Connection conn = Conexao.conectar();
              Statement stmt = conn.createStatement();
              ResultSet rs = stmt.executeQuery(sql)
                ){

            // Inserindo os valores nos objetos
            while (rs.next()){
                Disciplina d = new Disciplina();
                Nota n = new Nota();
                Observacao o = new Observacao();
                Aluno a = new Aluno();
                Professor p = new Professor();
                CasaHogwarts c = new CasaHogwarts();

                // Capturando valores da seleção
                d.setNome(rs.getString("disciplina"));
                d.setId(rs.getInt("id"));

                n.setNotaUm(rs.getDouble("nota_um"));
                n.setNotaDois(rs.getDouble("nota_dois"));

                o.setObservacao(rs.getString("observacao"));
                o.setId(rs.getInt("ob_id"));

                a.setNome(rs.getString("aluno"));
                a.setEmail(rs.getString("email"));
                a.setMatricula(rs.getInt("matricula"));

                p.setNome(rs.getString("professor"));

                c.setNome(rs.getString("casa_hogwarts"));

                // Geração do boletim
                boletins.add(new Boletim(a, n.getNotaUm(), n.getNotaDois(), o, d, p, c));
            } return boletins;
        } catch (SQLException | ClassNotFoundException e){
            e.printStackTrace();
        } return null;
    }

    // Método de login
    public boolean login(String email, String senha) throws ClassNotFoundException, SQLException, NoSuchAlgorithmException {
        String sql = "SELECT 1 FROM ALUNO WHERE EMAIL = ? AND SENHA = ?";
        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setString(2, Hash.hashSenha(senha));

            try (ResultSet rs = pstmt.executeQuery()){
                if(rs.next()){
                    return true; // é aluno
                    // false = não é aluno
                }
            }
        }
        return false;
    }

    // Validar cpf
    public static boolean validarCpf(String cpf) throws IOException{
        String caminho = "src/main/java/com/hogwarts/dao/cpfs.txt";
        File arquivo = new File(caminho);

        List<String> texto = new ArrayList<>();
        int contador = 0;


        Scanner inFile = new Scanner(arquivo);

        while(inFile.hasNextLine()){
            String linha = inFile.nextLine();
            texto.add(linha);
        }

        inFile.close();
        BufferedWriter bw = new BufferedWriter(new FileWriter(arquivo));

        if(texto.contains(cpf)){
            texto.remove(cpf);
            while(contador < texto.size()){
                bw.write(texto.get(contador));
                bw.newLine();
                contador ++;
            }
            return true;
        }
            bw.close();
        return false;
    }

    // Método cadastrar alunos (admin)
    public boolean cadastrar(Aluno aluno) throws SQLException, ClassNotFoundException, IOException {
        Conexao conexao = new Conexao();
        Connection conn = conexao.conectar();
        int retorno = 0;
        if (validarCpf(aluno.getCpf())){
            try {
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO ALUNO(NOME, CPF, EMAIL, SENHA, COD_CASA) VALUES (?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);
                pstmt.setString(1, aluno.getNome());
                pstmt.setString(2, aluno.getCpf());
                pstmt.setString(3, aluno.getEmail());
                pstmt.setString(4, aluno.getSenha());
                pstmt.setInt(5, aluno.getCasaHogwarts().getId());
                retorno = pstmt.executeUpdate();
                if (retorno > 0) {
                    ResultSet rs = pstmt.getGeneratedKeys();
                    if (rs.next()) {
                        int matricula = rs.getInt(1);
                        aluno.setMatricula(matricula);
                    }
                }

            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                conexao.desconectar(conn);
            }
        }
        return retorno > 0;
    }
}
