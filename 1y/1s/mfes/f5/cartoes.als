// Modelo abstracto de um sistema de emissão de cartões bancários

abstract sig Status {}
one sig Unissued, Issued, Cancelled extends Status {}

sig Card {
	var status : one Status
}

sig Client {
	var cards : set Card
}

// Algumas das propriedades desejadas para o sistema

assert NoUnissuedCards {
	// Os clientes nunca podem deter cartões unissued

}

assert NoSharedCards {
	// Ao longo da sua existência um cartão nunca pode pertencer a mais do que um cliente

}

// Especifique as condições iniciais do sistema

fact Init {

}

// Especifique as operações do sistema por forma a garantir as propriedades
// de segurança

check NoUnissuedCards
check NoSharedCards

// Operação de emitir um cartão para um cliente
pred emit [c : Card, a : Client] {

}

// Operação de cancelar um cartão
pred cancel [c : Card] {

}

pred nop {
	status' = status
	cards' = cards
}

fact Traces {
	always (nop or some c : Card | cancel[c] or some a : Client | emit[c,a])
}

// Especifique um cenário onde 3 cartões são emitidos a pelo menos 2
// clientes e são todos inevitavelmente cancelados, usando os scopes
// para controlar a cardinalidade das assinaturas
// Tente também definir um theme onde os cartões emitidos são verdes
// e os cancelados são vermelhos, ocultando depois toda a informação que
// seja redundante 
// Pode introduzir definições auxiliares no modelo se necessário

run Exemplo {

}
