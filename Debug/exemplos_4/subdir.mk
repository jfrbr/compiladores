################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../exemplos_4/teste.c 

OBJS += \
./exemplos_4/teste.o 

C_DEPS += \
./exemplos_4/teste.d 


# Each subdirectory must supply rules for building sources it contributes
exemplos_4/%.o: ../exemplos_4/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


