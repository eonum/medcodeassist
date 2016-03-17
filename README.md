# medcodeassist
Assistant for medical coding based on analysis of free text medical documentation

## API

### Tokenizations

Expects
- text

Returns
- list of {word, token, pos}

### Synonyms
Expects
- word
- count (of expected synonyms. Only makes sense because we are approximating synonyms by similar tokens. Will be removed when we switch to a real synonym database)

Returns
- list of simlar tokens ({name, similarity})

Note: At the moment we're approximating synonyms by using a similarity measure.

### Code Proposals
Expects
- list of input_codes and input_code_types (i.e. input_codes[i] has the type input_code_types[i])
- get_drgs, get_chops, get_icds (E.g. set get_drgs to true if you want a list of drgs. You can retrieve multiple types of codes at the same time.)
- count (How many codes per type you want to retrieve)

Returns
- list of {code, similarity}

### MongoDB
Run the database as follows: ``` mongod --dbpath [...]/medcodeassist/db --rest ```
- This will start the mongodb server at localhost:27017
- <q>--rest</q> will provide an http interface at localhost:28017
- <q>--dbpath [...]/medcodeassist/db</q> defines your data directory
