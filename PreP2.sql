CREATE DATABASE PREP2
GO
USE PREP2

CREATE TABLE Clientes (
Cod INT PRIMARY KEY,
Nome VARCHAR(100) NOT NULL,
Logradouro VARCHAR(100),
Numero INT,
Telefone CHAR(11));

CREATE TABLE Autores (
Cod INT PRIMARY KEY,
Nome VARCHAR(100) NOT NULL,
Pais VARCHAR(50) NOT NULL,
Biografia VARCHAR(200) NOT NULL);

CREATE TABLE Corredores (
Cod INT PRIMARY KEY,
Tipo VARCHAR(30) NOT NULL);

CREATE TABLE Livros (
Cod INT PRIMARY KEY,
Cod_Autor INT,
Cod_Corredores INT,
Nome VARCHAR(100) NOT NULL,
Pag INT NOT NULL CHECK (Pag > 0),
Idioma VARCHAR(30) NOT NULL


FOREIGN KEY (Cod_Autor) REFERENCES Autores(Cod),
FOREIGN KEY (Cod_Corredores) REFERENCES Corredores(Cod));

CREATE TABLE Emprestimo (
Cod_CLi INT ,
Dt_Emprestimo TIMESTAMP,
Cod_Livro INT

PRIMARY KEY (Cod_CLi,Cod_Livro),
FOREIGN KEY (Cod_CLi) REFERENCES Clientes(Cod),
FOREIGN KEY (Cod_Livro) REFERENCES Livros(Cod));

SELECT C.Nome, CONVERT(VARCHAR(10), E.Dt_Emprestimo, 103) AS Emprestimo
FROM Clientes C 
INNER JOIN Emprestimo E ON (E.Cod_CLi = C.Cod)

SELECT CASE WHEN LEN(A.Nome) > 25 THEN
SUBSTRING(A.Nome,1,13)
ELSE
A.Nome END AS Autor, COUNT(L.Cod)
FROM Autores A
INNER JOIN Livros L ON (L.Cod_Autor = A.Cod)
GROUP BY A.Nome


SELECT TOP 1 A.Nome AS Autor , A.Pais,MAX(L.Pag) as Paginas
FROM Autores A
INNER JOIN Livros L ON (L.Cod_Autor = A.Cod)
GROUP BY A.Nome,A.Pais
ORDER BY Paginas DESC;

SELECT DISTINCT(C.Nome) AS Cliente, CASE WHEN (C.Logradouro IS NOT NULL AND C.Numero IS NOT NULL) THEN
C.Logradouro + ' - ' + CAST(C.Numero AS VARCHAR(11))
WHEN (C.Logradouro IS NOT NULL AND C.Numero IS NULL) THEN
C.Logradouro
WHEN (C.Logradouro IS NULL AND C.Numero IS NOT NULL) THEN
CAST(C.Numero AS VARCHAR(11))
ELSE
'' END AS Endereco 
FROM Clientes C 
INNER JOIN Emprestimo E ON (E.Cod_CLi = C.Cod);

SELECT DISTINCT(C.Nome) AS Cliente, CASE 
WHEN (C.Logradouro IS NOT NULL AND C.Numero IS NOT NULL AND C.Telefone IS NOT NULL) THEN
C.Logradouro + ' - ' + CAST(C.Numero AS VARCHAR(11)) + ' - ' + SUBSTRING(C.Telefone,1,5) + '-' + SUBSTRING(C.Telefone,6,4)
WHEN (C.Logradouro IS NOT NULL AND C.Numero IS NULL AND C.Telefone IS NOT NULL) THEN
C.Logradouro + ' - ' + SUBSTRING(C.Telefone,1,5) + '-' + SUBSTRING(C.Telefone,6,4)
WHEN (C.Logradouro IS NULL AND C.Numero IS NOT NULL AND C.Telefone IS NULL) THEN
CAST(C.Numero AS VARCHAR(11))
WHEN (C.Logradouro IS NULL AND C.Numero IS NOT NULL AND C.Telefone IS NOT NULL) THEN
CAST(C.Numero AS VARCHAR(11)) + + ' - ' + SUBSTRING(C.Telefone,1,5) + '-' + SUBSTRING(C.Telefone,6,4)
WHEN (C.Logradouro IS NOT NULL AND C.Numero IS NULL AND C.Telefone IS NULL) THEN
C.Logradouro
WHEN (C.Logradouro IS NULL AND C.Numero IS NULL AND C.Telefone IS NOT NULL) THEN
SUBSTRING(C.Telefone,1,5) + '-' + SUBSTRING(C.Telefone,6,4)
WHEN (C.Logradouro IS NOT NULL AND C.Numero IS NOT NULL AND C.Telefone IS NULL) THEN
C.Logradouro + ' - ' + CAST(C.Numero AS VARCHAR(11))
ELSE
'' END AS Endereco_Telefone
FROM Clientes C 
LEFT JOIN Emprestimo E ON (E.Cod_CLi = C.Cod)
WHERE E.Cod_Cli IS NULL;

SELECT COUNT(L.Cod) AS Livros
FROM Livros L
LEFT OUTER JOIN Emprestimo E ON (E.Cod_Livro = L.Cod)
WHERE E.Cod_Livro IS NULL;

SELECT A.Nome AS Autor,C.Tipo AS Corredor, COUNT(L.Cod) AS Livros
FROM Autores A
INNER JOIN Livros L ON (L.Cod_Autor = A.Cod)
INNER JOIN Corredores C ON (C.Cod = L.Cod_Corredores)
GROUP BY A.NOME, C.Tipo
ORDER BY Livros

SELECT DISTINCT(C.Nome) AS Cliente, L.Nome AS Livro, DATEDIFF(DAY,E.Dt_Emprestimo,'2012-05-18 00:00:00.000') as Dias,
CASE WHEN DATEDIFF(DAY,E.Dt_Emprestimo,'2012-05-18 00:00:00.000') > 4 THEN
'Atrasado' 
ELSE
'No Prazo' 
END AS Status
FROM Clientes C 
INNER JOIN Emprestimo E ON (E.Cod_CLi = C.Cod)
INNER JOIN Livros L ON (L.Cod = E.Cod_Livro)


SELECT C.Cod, C.Tipo AS Corredor, COUNT(L.Cod) AS Livros
FROM Livros L 
INNER JOIN Corredores C ON (C.Cod = L.Cod_Corredores)
GROUP BY C.Cod,C.Tipo

SELECT A.Nome AS Autor
FROM Autores A
INNER JOIN Livros L ON (L.Cod_Autor = A.Cod)
GROUP BY A.Nome
HAVING COUNT(L.Cod) >= 2;

SELECT C.Nome
FROM Clientes C 
INNER JOIN Emprestimo E ON (E.Cod_CLi = C.Cod)
INNER JOIN Livros L ON (L.Cod = E.Cod_Livro)
WHERE DATEDIFF(DAY,E.Dt_Emprestimo,'2012-05-18 00:00:00.000') >= 7
GROUP BY C.Nome
