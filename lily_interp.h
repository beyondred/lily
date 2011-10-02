#ifndef LILY_INTERP_H
# define LILY_INTERP_H

# include "lily_error.h"
# include "lily_parser.h"

typedef struct lily_interp_t {
    lily_excep_data *error;
    lily_parse_state *parser;
} lily_interp;

lily_interp *lily_new_interp(void);
void lily_interp_free(lily_interp *);
int lily_parse_file(lily_interp *, char *);

#endif
