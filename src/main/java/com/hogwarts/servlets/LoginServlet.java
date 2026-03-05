package com.hogwarts.servlets;

import com.hogwarts.model.banco.Usuario; // <- use este pacote correto

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

@WebServlet("/login-servlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("login"); // do cadastro antigo
        String senha = request.getParameter("senha");

        if (login == null || senha == null) {
            response.sendRedirect("cadastroantigo.html?erro=campos");
            return;
        }

        // Regex para diferenciar aluno e professor
        Pattern alunoPattern = Pattern.compile("^[a-zA-Z]+\\.[a-zA-Z]+@hogwarts\\.com$");
        Pattern professorPattern = Pattern.compile("^[a-zA-Z]+\\.[a-zA-Z]+$");

        Matcher alunoMatcher = alunoPattern.matcher(login);
        Matcher professorMatcher = professorPattern.matcher(login);

        Usuario usuario = null;

        try {
            Connection conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost:5432/seuBanco",
                    "usuarioBanco",
                    "senhaBanco");

            String sql = "SELECT login, senha, tipo FROM usuarios WHERE login = ? AND senha = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, login);
            stmt.setString(2, senha);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                usuario = new Usuario(
                        rs.getString("login"),
                        rs.getString("senha"),
                        rs.getString("tipo"));
            }

            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("cadastroantigo.html?erro=banco");
            return;
        }

        if (usuario == null) {
            response.sendRedirect("cadastroantigo.html?erro=login");
            return;
        }

        // Cria sessão
        HttpSession session = request.getSession();
        session.setAttribute("usuarioLogado", usuario);

        String contexto = request.getContextPath();

        if (alunoMatcher.matches() && usuario.getTipo().equalsIgnoreCase("ALUNO")) {
            response.sendRedirect(contexto + "/aluno/inicial.jsp");
        } else if (professorMatcher.matches() && usuario.getTipo().equalsIgnoreCase("PROFESSOR")) {
            response.sendRedirect(contexto + "/prof/inicial.jsp");
        } else {
            response.sendRedirect(contexto + "/cadastroantigo.html?erro=formato");
        }
    }
}