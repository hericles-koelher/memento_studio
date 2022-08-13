# Memento Studio
Memento Studio (“Lembre-se de Estudar” em latim) é um aplicativo de flashcards que visa auxiliar estudantes em suas jornadas de estudo. A ideia é que o aplicativo permita que os usuários criem/busquem baralhos e possam utilizá-los para treinar/reforçar suas memórias acerca de um conteúdo alvo. De posse de um baralho, qualquer usuário retentor de uma conta em nossa plataforma poderá compartilhar sua criação com outros usuários (cadastrados ou não).

<p align="middle">
  <img src="https://user-images.githubusercontent.com/42984505/184510631-9c33c143-56e4-4649-b24f-45dff3556a4f.jpg" width="250" hspace="20" />
  <img src="https://user-images.githubusercontent.com/42984505/184510634-13532544-e1c3-485e-8246-b6ce8ab31bc6.jpg" width="250" hspace="20"/> 
</p>

## Principais tecnologias utilizadas
Servidor
- [Golang](https://go.dev/)
- [Web Gin](https://gin-gonic.com/)
- [MongoDB](https://www.mongodb.com/)

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

Para que seu dispositivo consiga se comunicar com o servidor que está rodando no localhost, é necessário expor a porta 8080 para internet de maneira segura. Recomendamos a utilização do `ngrok`, que pode ser instalado seguindo os passos [desse link](https://ngrok.com/download). Depois de instalar o `ngrok`, vá para a pasta onde o executável está e execute:

```sh
./ngrok http 8080
```
Você verá algo parecido com a imagem abaixo.

![image](https://user-images.githubusercontent.com/42984505/184511252-4a5b81dd-5626-49cf-a718-63fe3e067b2f.png)

Uma url será gerada, copie-a e substitua o valor da variável `baseUrl` em `app/lib/src/utils/constants.dart`. No meu caso, a url gerada foi `https://bf68-2804-56c-a4d0-d000-1daf-e3e5-927b-af6b.sa.ngrok.io`.

### Mobile:
Com um smartphone conectado ao computador, execute o seguinte comando. 
```sh
cd app ; flutter run; cd ..
```

## Exemplo de uso

TODO

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
