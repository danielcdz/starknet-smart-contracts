#[starknet::interface]
trait ICalculator<TContractState> {
    fn set_owner(ref self: TContractState, new_owner: ByteArray);
    fn is_on(self: @TContractState) -> bool;
    fn turn_off(ref self: TContractState);
    fn turn_on(ref self: TContractState);
    fn sum(ref self: TContractState, a: u128, b: u128);
    fn sub(ref self: TContractState, a: u128, b: u128);
    fn div(ref self: TContractState, a: u128, b: u128);
    fn sum_result(self: @TContractState) -> u128;
    fn sub_result(self: @TContractState) -> u128;
    fn div_result(self: @TContractState) -> u128;
    fn mult_result(self: @TContractState) -> u128;
    fn return_result_of(self: @TContractState, operation: felt252) -> u128;
}

#[starknet::contract]
mod Calculator{
    use super::ICalculator;

    #[storage]
    struct Storage {
        owner: ByteArray,
        power: bool,
        sum_result: u128,
        sub_result: u128,
        div_result: u128,
        mult_result: u128,
        fallback_value: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write("I don't have an owner");
        self.power.write(true);
        self.sum_result.write(0);
        self.sub_result.write(0);
        self.div_result.write(0);
        self.mult_result.write(0);
        self.fallback_value.write(0);
    }

    #[abi(embed_v0)]
    impl CalculatorImpl of ICalculator<ContractState> {
        fn set_owner(ref self: ContractState, new_owner: ByteArray) {
            self.owner.write(new_owner)
        }

        fn is_on(self: @ContractState) -> bool {
            self.power.read()
        }

        fn turn_off(ref self: ContractState) {
            self.power.write(false)
        }

        fn turn_on(ref self: ContractState) {
            self.power.write(true)
        }

        fn sum(ref self: ContractState, a: u128, b: u128) {
            self.sum_result.write(a + b)
        }

        fn sub(ref self: ContractState, a: u128, b: u128) {
            self.sub_result.write(a - b)
        }

        fn div(ref self: ContractState, a: u128, b: u128) {
            self.div_result.write( a / b)
        }

        fn sum_result(self: @ContractState) -> u128 {
            self.sum_result.read()
        }

        fn sub_result(self: @ContractState) -> u128 {
            self.sub_result.read()
        }

        fn div_result(self: @ContractState) -> u128 {
            self.div_result.read()
        }

        fn mult_result(self: @ContractState) -> u128 {
            self.mult_result.read()
        }

        fn return_result_of(self: @ContractState, operation: felt252) -> u128 {
            if operation == 'sum' {
                self.sum_result()
            }
            else if operation == 'sub' {
                self.sub_result()
            }
            else if operation == 'div' {
                self.div_result()
            }
            else if operation == 'mult' {
                self.mult_result()
            }
            else {
                self.fallback_value.read()
            }
        }
    }
}