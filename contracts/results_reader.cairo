#[starknet::interface]
trait IResultReader<TContractState> {
    fn write_message(self: @TContractState);
    fn read_message(self: @TContractState) -> ByteArray;
}

#[starknet::contract]
mod ResultReader{
    use super::ICalculator;
    use super::{ICalculatorDispatcherTrait, ICalculatorLibraryDispatcher};
    use core::starknet::{ContractAddress, ClassHash};
    use core::fmt::Formatter;

    #[storage]
    struct Storage {
        logic_library: ClassHash,
        message: ByteArray
    }

    #[constructor]
    fn constructor(ref self: ContractState, logic_library: ClassHash) {
        self.logic_library.write(logic_library);
    }

    #[abi(embed_v0)]
    impl ResultReaderImpl of IResultReader<ContractState> {
        fn write_message(self: @ContractState) {
            let result_from_calculator: u128 = IValueStoreLibraryDispatcher { class_hash: self.logic_library.read() }.sum_result();
            let mut formatter: Formatter = Default::default();
            write!(formatter, "The result of the sum is: ");
            write!(formatter, "{result_from_calculator}");
            self.message.write(formatter.buffer)
        }

        fn read_message(self: @ContractState) -> ByteArray{
            self.message.read()
        }

    }
}