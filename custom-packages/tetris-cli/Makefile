SRC		=	src/game.cpp \
			src/main.cpp \
			src/tetromino.cpp

OBJ		=	$(SRC:.cpp=.o)

NAME	=	tetris

all: $(NAME)

$(NAME): $(OBJ)
	$(CXX) -lncurses -o $(NAME) $(OBJ) $(CXXFLAGS)

clean:
	rm -f $(OBJ)

fclean: clean

re: fclean all
