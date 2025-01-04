
FORMULAFILES =	formula/aalta_formula.cpp formula/olg_formula.cpp formula/olg_item.cpp
	
PARSERFILES  =	ltlparser/ltl_formula.c ltlparser/ltllexer.c ltlparser/ltlparser.c ltlparser/trans.c 

UTILFILES    =	util/utility.cpp utility.cpp

SOLVER		= minisat/core/Solver.cc aaltasolver.cpp solver.cpp carsolver.cpp 

CHECKING	= ltlfchecker.cpp carchecker.cpp  

OTHER		= evidence.cpp


ALLFILES     =	$(CHECKING) $(SOLVER) $(FORMULAFILES) $(PARSERFILES) $(UTILFILES) $(OTHER) main.cpp


CC	    =   g++
FLAG    = -I./  -I./minisat/  -D __STDC_LIMIT_MACROS -D __STDC_FORMAT_MACROS -fpermissive
DEBUGFLAG   =	-D DEBUG -g -pg
RELEASEFLAG = -O2
TARGET       = aaltaf
SHARED_LIB   = libprocess.so

.PHONY: all release debug clean

all: release

# 生成 C 文件
ltlparser/ltllexer.c :
	ltlparser/grammar/ltllexer.l
	flex ltlparser/grammar/ltllexer.l

ltlparser/ltlparser.c :
	ltlparser/grammar/ltlparser.y
	bison ltlparser/grammar/ltlparser.y

# 生成共享库
$(SHARED_LIB): $(FORMULAFILES) $(UTILFILES) $(SOLVER)
	$(CC) -shared -fPIC -o $@ $^ $(FLAG)

aaltaf :	release

ltlparser/ltllexer.c :
	ltlparser/grammar/ltllexer.l
	flex ltlparser/grammar/ltllexer.l

ltlparser/ltlparser.c :
	ltlparser/grammar/ltlparser.y
	bison ltlparser/grammar/ltlparser.y
	

.PHONY :    release debug clean

release :   $(ALLFILES) $(SHARED_LIB)
	    $(CC) $(FLAG) $(RELEASEFLAG) $(ALLFILES) -lz -o aaltaf

debug :	$(ALLFILES) $(SHARED_LIB)
	$(CC) $(FLAG) $(DEBUGFLAG) $(ALLFILES) -lz -o aaltaf

clean :
	rm -f *.o *~ aaltaf $(SHARED_LIB)
