<h1>Memento Studio</h1>

<!-- TODO: Arrumar isso aqui no final -->
<p>
 <a href="#about">About</a> •
 <a href="#features">Features</a> •
 <a href="#how-it-works">How it works</a> •
 <a href="#tech-stack">Tech Stack</a> •
 <a href="#author">Author</a> •
 <a href="#user-content-license">License</a>

</p>

---

Memento Studio (“Lembre-se de Estudar” em latim) é um aplicativo de flash cards que visa auxiliar estudantes em suas jornadas de estudo. A ideia é que o aplicativo permita que os usuários criem/busquem baralhos e possam utilizá-los para treinar/reforçar suas memórias acerca de um conteúdo alvo. De posse de um baralho, qualquer usuário retentor de uma conta em nossa plataforma poderá compartilhar sua criação com outros usuários (cadastrados ou não).

<p align="middle">
  <img src="https://user-images.githubusercontent.com/42984505/184510631-9c33c143-56e4-4649-b24f-45dff3556a4f.jpg" width="250" hspace="20" />
  <img src="https://user-images.githubusercontent.com/42984505/184510634-13532544-e1c3-485e-8246-b6ce8ab31bc6.jpg" width="250" hspace="20"/> 
</p>

## Principais tecnologias utilizadas
Servidor
- [Golang](https://go.dev/)
- [Web Gin](https://gin-gonic.com/)
- [MongoDB](https://www.mongodb.com/)
- [Docker](https://www.docker.com/)

Mobile
- [Dart](https://dart.dev/)
- [Flutter](https://flutter.dev/)
- [ObjectBox](https://objectbox.io/)

## Instalação e uso
### Servidor:
É necessário ter docker e docker-compose instalados em seu computador. Para construir a imagem do servidor, execute o seguinte comando.
```sh
cd server ; docker-compose build; cd ..
```
Para executar o servidor na porta `8080` execute:
```sh
cd server ; docker-compose up; cd ..
```

Caso queira utilizar o aplicativo no emulador não precisa configurar nada muito especifico, mas caso queira usar o aplicativo em seu dispositivo, então é necessário expor a porta 8080 para internet de maneira segura. Recomendamos a utilização do `ngrok`, que pode ser instalado seguindo os passos [desse link](https://ngrok.com/download). Depois de instalar o `ngrok`, vá para a pasta onde o executável está e execute:

```sh
./ngrok http 8080
```
Você verá algo parecido com a imagem abaixo.

![image](https://user-images.githubusercontent.com/42984505/184511252-4a5b81dd-5626-49cf-a718-63fe3e067b2f.png)

Uma url será gerada, copie-a e substitua o valor da variável `baseUrl` em `app/lib/src/utils/constants.dart`. No meu caso, a url gerada foi `https://bf68-2804-56c-a4d0-d000-1daf-e3e5-927b-af6b.sa.ngrok.io`.

### Mobile:
Para executar o aplicativo é necessário que você tenha o [Android Studio](https://developer.android.com/studio) e [Flutter](https://docs.flutter.dev/get-started/install) instalados e configurados. Além disso, caso queira realizar login no app também deverá configurar o [Firebase](https://firebase.google.com/docs/flutter/setup?hl=pt-br&platform=android), [Facebook](https://facebook.meedu.app/docs/4.x.x/android) e o [Google](https://developers.google.com/identity/sign-in/android/start-integrating), esses dois ultimos somente caso queira realizar login com a plataforma.

Depois de configurar o necessário, basta ter um smartphone conectado ao computador e executar o seguinte comando. 
```sh
cd app ; flutter run; cd ..
```

## Demonstração

[![Video de demonstração do Memento Studio](https://img.youtube.com/vi/btnbJ5YypJ8/0.jpg)](https://www.youtube.com/watch?v=btnbJ5YypJ8)

## Documentação
Para visualizar a documentação do backend, feita com [Godoc](https://pkg.go.dev/golang.org/x/tools/cmd/godoc), execute o comando:

```sh
godoc -http=:6060 --goroot $PWD/server

```

E abra o navegador em [`localhost:6060/pkg`](http://localhost:6060/pkg)

## Autores

Hericles Bruno Koelher – [@hericles-koelher](https://github.com/hericles-koelher) – brunokoelher@hotmail.com

Mikaella Ferreira – [@mikaellafs](https://github.com/mikaellafs) – mikaellaferreira0@gmail.com

## Contributing

1. Faça o _fork_ do projeto (<https://github.com/yourname/yourproject/fork>)
2. Crie uma _branch_ para sua modificação (`git checkout -b feature/fooBar`)
3. Faça o _commit_ (`git commit -am 'Add some fooBar'`)
4. _Push_ (`git push origin feature/fooBar`)
5. Crie um novo _Pull Request_
