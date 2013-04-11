################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../exemplos/in1.c \
../exemplos/in2.c \
../exemplos/in3.c \
../exemplos/in4.c \
../exemplos/in5.c \
../exemplos/inerr1.c \
../exemplos/inerr2.c \
../exemplos/inerr3.c \
../exemplos/inerr4.c \
../exemplos/inerr5.c 

OBJS += \
./exemplos/in1.o \
./exemplos/in2.o \
./exemplos/in3.o \
./exemplos/in4.o \
./exemplos/in5.o \
./exemplos/inerr1.o \
./exemplos/inerr2.o \
./exemplos/inerr3.o \
./exemplos/inerr4.o \
./exemplos/inerr5.o 

C_DEPS += \
./exemplos/in1.d \
./exemplos/in2.d \
./exemplos/in3.d \
./exemplos/in4.d \
./exemplos/in5.d \
./exemplos/inerr1.d \
./exemplos/inerr2.d \
./exemplos/inerr3.d \
./exemplos/inerr4.d \
./exemplos/inerr5.d 


# Each subdirectory must supply rules for building sources it contributes
exemplos/%.o: ../exemplos/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


