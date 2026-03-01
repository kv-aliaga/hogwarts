 // parte de verificação
   document.addEventListener("DOMContentLoaded", function () {

    const btnConcluirCadastro = document.getElementById("botao-principal");

    btnConcluirCadastro.addEventListener("click", function (event) {

        event.preventDefault(); // impede envio automático do form

        const aluno = document.getElementById("aluno").value.trim();
        const cpf = document.getElementById("cpf").value.trim();
        const email = document.getElementById("email").value.trim();
        const casa = document.getElementById("casa").value.trim();
        const senha = document.getElementById("senha").value.trim();
        const confSenha = document.getElementById("confirmar-senha").value.trim();

        if (!aluno || !cpf || !email || !casa || !senha || !confSenha) {
            alert("Todos os campos devem ser preenchidos!");
            return;
        }

        if (senha !== confSenha) {
            alert("O campo 'confirmar senha' esta diferente da senha!");
            return;
        }

        alert("Cadastro realizado com sucesso!");
    });

});
