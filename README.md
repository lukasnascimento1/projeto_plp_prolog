# 🧩 Sudoku em Prolog

Implementação de um resolvedor de Sudoku utilizando **Prolog**, com foco educacional no aprendizado de programação lógica e modelagem declarativa de problemas.

---

## 📚 Objetivo

Este projeto tem como finalidade:

- Aprender Prolog desde os fundamentos
- Compreender unificação, recursão e backtracking
- Aplicar programação com restrições
- Modelar um problema clássico (Sudoku) de forma declarativa

O Sudoku é ideal para estudar Prolog porque pode ser descrito inteiramente como um conjunto de restrições lógicas.

---

## 🧠 Sobre a Abordagem

Diferente de linguagens imperativas, em Prolog não descrevemos *como* resolver o problema passo a passo. Em vez disso, descrevemos:

- As regras que devem ser verdadeiras
- As restrições que precisam ser satisfeitas

O motor lógico do Prolog encontra automaticamente uma solução válida através de:

- Unificação
- Resolução lógica
- Backtracking
- Programação com domínios finitos (CLP(FD))

---

## 🎯 Regras do Sudoku

Uma solução válida deve satisfazer:

- Cada linha contém números de 1 a 9 sem repetição
- Cada coluna contém números de 1 a 9 sem repetição
- Cada bloco 3x3 contém números de 1 a 9 sem repetição

---

## 🛠️ Requisitos

- SWI-Prolog  
  https://www.swi-prolog.org/

---

## ▶️ Como Executar

1. Clone o repositório:

```bash
git clone https://github.com/seu-usuario/sudoku-prolog.git
cd sudoku-prolog
