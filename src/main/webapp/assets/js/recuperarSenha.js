document.addEventListener("DOMContentLoaded", function () {

    const btnRecuperar = document.getElementById("botao-recuperar");

    btnRecuperar.addEventListener("click", function (event) {
        event.preventDefault();

        emailjs.init("SUA_PUBLIC_KEY_CORRETA");

        const email = document.getElementById("email-recuperacao").value.trim();

        if (!email) {
            alert("Digite um email.");
            return;
        }

        // gera senha
        const caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        let senha = "";
        for (let i = 0; i < 5; i++) {
            senha += caracteres.charAt(Math.floor(Math.random() * caracteres.length));
        }

        const parametros = {
            email_destino: email,
            mensagem: "Sua senha temporária é: " + senha
        };

        console.log("Tentando enviar para:", email);
        console.log("Parametros:", parametros);

        emailjs.send("SEU_SERVICE_ID_CORRETO", "SEU_TEMPLATE_ID_CORRETO", parametros)
            .then(function () {
                document.getElementById("mensagem").innerText =
                    "Email enviado com sucesso!";
                console.log("Senha enviada:", senha);
            })
            .catch(function (error) {
                document.getElementById("mensagem").innerText =
                    "Erro ao enviar email.";
                console.error("Erro:", error);
            });
    });

});