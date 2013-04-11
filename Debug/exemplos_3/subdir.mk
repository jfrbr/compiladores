################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../exemplos_3/inerr1.c \
../exemplos_3/inerr2.c \
../exemplos_3/inerr3.c \
../exemplos_3/inerr4.c \
../exemplos_3/inerr5.c 

OBJS += \
./exemplos_3/inerr1.o \
./exemplos_3/inerr2.o \
./exemplos_3/inerr3.o \
./exemplos_3/inerr4.o \
./exemplos_3/inerr5.o 

C_DEPS += \
./exemplos_3/inerr1.d \
./exemplos_3/inerr2.d \
./exemplos_3/inerr3.d \
./exemplos_3/inerr4.d \
./exemplos_3/inerr5.d 


# Each subdirectory must supply rules for building sources it contributes
exemplos_3/%.o: ../exemplos_3/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


