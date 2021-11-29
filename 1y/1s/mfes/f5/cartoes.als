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
	always no cards.status.Unissued
}

assert NoSharedCards {
	// Ao longo da sua existência um cartão nunca pode pertencer a mais do que um cliente
	all c : Card | some cards.c implies always (one cards.c or cards.c = cards'.c)
}

// Especifique as condições iniciais do sistema

fact Init {
	no cards
	status = status :> (Issued + Cancelled)
}

// Especifique as operações do sistema por forma a garantir as propriedades
// de segurança

check NoUnissuedCards
check NoSharedCards

// Operação de emitir um cartão para um cliente
pred emit [c : Card, a : Client] {
	// guard
	c.status = Unissued and c not in a.cards

	// effect
	cards' = cards + a->c
	status' = status - c->Unissued + c->Issued
	
	// frame conditions
	// implict in the effect
}

// Operação de cancelar um cartão
pred cancel [c : Card] {
	// guard
	c.status = Issued

	// effect
	status' = status - c->Issued + c->Cancelled
	
	// frame conditions
	cards' = cards
}

pred nop {
	status' = status
	cards' = cards
}

fact Traces {
	always { nop or 
			 (some c : Card | cancel[c] or some a : Client | emit[c,a])
		   }
}


// Especifique um cenário onde 3 cartões são emitidos a pelo menos 2
// clientes e são todos inevitavelmente cancelados, usando os scopes
// para controlar a cardinalidade das assinaturas
// Tente também definir um theme onde os cartões emitidos são verdes
// e os cancelados são vermelhos, ocultando depois toda a informação que
// seja redundante 
// Pode introduzir definições auxiliares no modelo se necessário

// For themes!

fun issuedCards : set Card {
	status.Issued
}

fun unissuedCards : set Card {
	status.Unissued
}

fun cancelledCards : set Card {
	status.Cancelled
}

// end

run Exemplo {

}
