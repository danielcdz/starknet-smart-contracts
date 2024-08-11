#[starknet::interface]
trait ICalculator<TContractState> {
    fn is_on(self: @TContractState) -> bool;
    fn turn_off(self: @TContractState);
    fn turn_on(self: @TContractState);
    fn sum(ref self: @TContractState, a: u128, b: 128);
    fn sub(ref self: @TContractState, a: u128, b: 128);
    fn div(ref self: @TContractState, a: u128, b: 128);
    fn sum_result(self: @TContractState) -> u128;
    fn sub_result(self: @TContractState) -> u128;
    fn div_result(self: @TContractState) -> u128;
}

#[starknet::contract]
mod Calculator{
    use super::ICalculator;

    #[storage]
    struct Storage {
        power: bool,
        sum_result: u128,
        sub_result: u128,
        div_result: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.power.write(true);
        self.sum_result.write(0);
        self.sub_result.write(0);
        self.div_result.write(0);
    }

    #[abi(embed_v0)]
    impl CalculatorImpl of ICalculator<ContractState> {
        fn is_on(self: @ContractState) -> bool {
            self.power.read()
        }

        fn turn_off(ref self: TContractState) {
            self.power.write(false)
        }

        fn turn_on(ref self: TContractState) {
            self.power.write(true)
        }

        fn sum(ref self: TContractState, a: u128, b: 128) {
            self.sum_result.write(a + b)
        }

        fn sub(ref self: TContractState, a: u128, b: 128) {
            self.sub_result.write(a - b)
        }

        fn div(ref self: TContractState, a: u128, b: 128) {
            self.div_result.write( a \ b)
        }

        fn sum_result(self: @TContractState) -> u128 {
            self.sum_result.read()
        }

        fn sub_result(self: @TContractState) -> u128 {
            self.sub_result.read()
        }

        fn div_result(self: @TContractState) -> u128 {
            self.div_result.read()
        }

    }
}