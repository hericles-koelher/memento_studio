package mongoutils

import (
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Estrutura de paginação do mongo
type MongoPaginate struct {
	limit int64
	page  int64
}

// Cria uma nova estrutura de paginação a partir de um 'limit' e 'page'
func NewMongoPaginate(limit, page int) *MongoPaginate {
	return &MongoPaginate{
		limit: int64(limit),
		page:  int64(page),
	}
}

// Gera um objeto do tipo 'FindOptions' que é utilizado pelo mongodb para filtrar o resultado de uma operação 'find'.
// O skip de elementos é gerado com 'page' e 'limit' da estrutura 'MongoPaginate'.
func (mp *MongoPaginate) GetPaginatedOpts() *options.FindOptions {
	l := mp.limit
	skip := mp.page*mp.limit - mp.limit
	fOpt := options.FindOptions{Limit: &l, Skip: &skip}

	return &fOpt
}
