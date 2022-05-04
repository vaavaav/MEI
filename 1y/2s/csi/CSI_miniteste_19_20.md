# Questão 1

```

π1 . R ⊆ P . <F, π2>

≡ {Pointwise (5.11); (5.19)}

<∀ d, a, al :: <∃ nf,d' : d π1 (d',nf) : (d',nf) R (a,al)> => <∃ c,al' : d P (c,al') : (c,al') <F, π2> (a,al) > >

≡ {(A.2); (A.6)}

<∀ d, a, al :: (d,nf) R (a,al) => <∃ c : d P (c, al') : c F (a,al) /\ al' π2 (a,al) > >

≡ {(A.2); (A.6)}

<∀ d, a, al :: (d,nf) R (a,al) => c F (a,al) /\ d P (c, al)>

```

Para toda a disciplina, aluno e ano letivo, se um aluno teve uma nota final a uma disciplina num dado ano letivo, então necessariamente existe um curso frequentado por esse aluno e ao qual pertence essa disciplina, nesse mesmo ano letivo.

---

- `π1 . R` dá as notas finais e disciplinas associadas a um aluno para um ano letivo.
Dizer que isto é simples é dizer que um aluno, num ano letivo, tem apenas uma nota final a uma unica disciplina.

Isto não é relevante.

...

# Questão 3

```

[<R,S>,<Q,V>] = <[R,Q],[S,V]>

≡ {(5.114)}

<R,S> = <[R,Q],[S,V]> . i1
<Q,V> = <[R,Q],[S,V]> . i2

≡ {(5.105)}

<R,S> = <[R,Q] . i1, [S,V] . i1>
<Q,V> = <[R,Q] . i2,[S,V] . i2>

≡ {(5.114)}

<R,S> = <R,S>
<Q,V> = <Q,V>

≡ {}

TRUE


```


