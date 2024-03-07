module transfer::transfer {
    use sui::coin::{Self, Coin};
    use sui::object::{Self, /* Object provides functionalities for dealing with objects in Sui */};

    // Transfers `amount` of SUI from `sender` to `recipient`.
    public fun transfer_sui(sender: &signer, recipient: address, amount: u64) {
        // Withdraw the specified amount of SUI from the sender's account.
        let sender_sui_coin = Coin::withdraw(sender, amount);

        // If the recipient already has a SUI balance, deposit the amount to their existing balance.
        // Otherwise, create a new coin object in the recipient's account.
        if (Object::exists_at_address<Coin<Sui>>(recipient)) {
            let recipient_sui_coin = Object::borrow_global_mut<Coin<Sui>>(recipient);
            Coin::merge(recipient_sui_coin, sender_sui_coin);
        } else {
            Object::move_to(sender_sui_coin, recipient);
        }
    }
}