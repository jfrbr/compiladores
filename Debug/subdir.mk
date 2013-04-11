################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../atrib.o \
../exp.o \
../fator.o \
../function.o \
../hash.o \
../list.o \
../parser.o \
../termo.o \
../tree.o \
../u_exp.o \
../u_exp_list.o \
../variable.o 

C_SRCS += \
../analisador_sintatico.tab.c \
../atrib.c \
../exp.c \
../fator.c \
../function.c \
../hash.c \
../lex.yy.c \
../list.c \
../parser.c \
../termo.c \
../teste.c \
../teste_bolado.c \
../tree.c \
../u_exp.c \
../u_exp_list.c \
../variable.c 

OBJS += \
./analisador_sintatico.tab.o \
./atrib.o \
./exp.o \
./fator.o \
./function.o \
./hash.o \
./lex.yy.o \
./list.o \
./parser.o \
./termo.o \
./teste.o \
./teste_bolado.o \
./tree.o \
./u_exp.o \
./u_exp_list.o \
./variable.o 

C_DEPS += \
./analisador_sintatico.tab.d \
./atrib.d \
./exp.d \
./fator.d \
./function.d \
./hash.d \
./lex.yy.d \
./list.d \
./parser.d \
./termo.d \
./teste.d \
./teste_bolado.d \
./tree.d \
./u_exp.d \
./u_exp_list.d \
./variable.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


