// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

/// Address has insufficient funds for this operation
error InsufficientBalanceError();
/// Name is too long. Max 8 characters allowed.
error NameTooLong();
///  Cannot send to the zero-address
error ZeroAddressError();
/// Tier allowed numbers: 1, 2 or 3
error InvalidTierProvidedError();
/// Invalid amount provided: must be greater than amount_
error InvalidAmountProvidedError(uint256 amount_);
/// Invalid ID provided, must be greater than 0
error InvalidIDProvidedError();
/// Only admin or owner can make this transaction
error OnlyAdminOrOwnerError();

contract GasContract {
    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }

    uint256 public totalSupply; // cannot be changed
    uint256 public paymentCounter;
    uint256 public constant tradePercent = 12;
    uint256 public tradeMode;
    mapping(address => uint256) public balances;
    mapping(address => Payment[]) public payments;
    mapping(address => uint256) public whitelist;
    mapping(address => bool) public isOddWhitelistUser;
    mapping(address => bool) public administrators;

    PaymentType constant DEFAULT_PAYMENT = PaymentType.Unknown;
    History[] public paymentHistory; // when a payment was updated

    struct Payment {
        uint256 paymentID;
        uint256 amount;
        address recipient;
        string recipientName; // max 8 characters
        bool adminUpdated;
        PaymentType paymentType;
        address admin; // administrators address
    }

    struct History {
        uint256 lastUpdate;
        uint256 blockNumber;
        address updatedBy;
    }
    struct ImportantStruct {
        uint16 valueA; // max 3 digits
        uint16 valueB; // max 3 digits
        uint256 bigValue;
    }

    mapping(address => ImportantStruct) public whiteListStruct;

    bool constant tradeFlag = true;
    bool constant dividendFlag = true;
    bool wasLastOdd = true;
    address _owner = msg.sender;

    event AddedToWhitelist(address userAddress, uint256 tier);
    event SupplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(
        address admin,
        uint256 ID,
        uint256 amount,
        string recipient
    );
    event WhiteListTransfer(address indexed);

    modifier onlyAdminOrOwner() {
        if (_owner != msg.sender || !checkForAdmin(msg.sender)) {
            revert OnlyAdminOrOwnerError();
        }
        _;
    }

    modifier checkIfWhiteListed() {
        uint256 usersTier = whitelist[msg.sender];
        if (usersTier < 1 || usersTier > 3) {
            revert InvalidTierProvidedError();
        }
        _;
    }

    constructor(address[5] memory _admins, uint256 _totalSupply) {
        totalSupply = _totalSupply;

        for (uint256 i = 0; i < _admins.length; i++) {
            if (_admins[i] == address(0)) {
                continue;
            }
            administrators[_admins[i]] = true;
            if (_admins[i] == _owner) {
                balances[_owner] = totalSupply;
            }
            emit SupplyChanged(_admins[i], balances[_admins[i]]);
        }
    }

    function getPaymentHistory()
        public
        view
        returns (History[] memory paymentHistory_)
    {
        return paymentHistory;
    }

    function checkForAdmin(address _user) public view returns (bool) {
        return administrators[_user];
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        return balances[_user];
    }

    function getTradingMode() public pure returns (bool mode_) {
        return tradeFlag || dividendFlag;
    }

    function addHistory(address _updateAddress, bool _tradeMode)
        public
        returns (bool status_, bool tradeMode_)
    {
        History memory history;
        history.blockNumber = block.number;
        history.lastUpdate = block.timestamp;
        history.updatedBy = _updateAddress;
        paymentHistory.push(history);
        bool status = tradePercent > 0 ? true : false;
        return (status, _tradeMode);
    }

    function getPayments(address _user)
        public
        view
        returns (Payment[] memory payments_)
    {
        if (_user == address(0)) {
            revert ZeroAddressError();
        }
        return payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public returns (bool status_) {
        if (balances[msg.sender] < _amount) {
            revert InsufficientBalanceError();
        }
        if (bytes(_name).length > 8) {
            revert NameTooLong();
        }
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        Payment memory payment = Payment(
            ++paymentCounter,
            _amount,
            _recipient,
            _name,
            false,
            PaymentType.BasicPayment,
            address(0)
        );
        payments[msg.sender].push(payment);

        emit Transfer(_recipient, _amount);

        if (tradePercent > 0) {
            return true;
        } else {
            return false;
        }
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) public onlyAdminOrOwner {
        if (_ID < 1) {
            revert InvalidIDProvidedError();
        }
        if (_amount < 1) {
            revert InvalidAmountProvidedError(0);
        }
        if (_user == address(0)) {
            revert ZeroAddressError();
        }

        for (uint256 i = 0; i < payments[_user].length; i++) {
            if (payments[_user][i].paymentID == _ID) {
                payments[_user][i].adminUpdated = true;
                payments[_user][i].admin = _user;
                payments[_user][i].paymentType = _type;
                payments[_user][i].amount = _amount;
                addHistory(_user, getTradingMode());
                emit PaymentUpdated(
                    msg.sender,
                    _ID,
                    _amount,
                    payments[_user][i].recipientName
                );
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier)
        public
        onlyAdminOrOwner
    {
        if (_tier < 1 || _tier > 3) {
            revert InvalidTierProvidedError();
        }
        whitelist[_userAddrs] = _tier;

        if (wasLastOdd) {
            isOddWhitelistUser[_userAddrs] = wasLastOdd;
            wasLastOdd = false;
        } else if (!wasLastOdd) {
            delete isOddWhitelistUser[_userAddrs];
            wasLastOdd = true;
        }
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct memory _struct
    ) public checkIfWhiteListed {
        if (balances[msg.sender] < _amount) {
            revert InsufficientBalanceError();
        }
        if (amount < 4) {
            revert InvalidAmountProvidedError(3);
        }
        balances[msg.sender] -= _amount - whitelist[msg.sender];
        balances[_recipient] += _amount + whitelist[msg.sender];

        // ImportantStruct storage newImportantStruct;
        // newImportantStruct.valueA = _struct.valueA;
        // newImportantStruct.bigValue = _struct.bigValue;
        // newImportantStruct.valueB = _struct.valueB;
        // whiteListStruct[msg.sender] = newImportantStruct; // was this missed or can we delete the important struct stuff altogether?
        emit WhiteListTransfer(_recipient);
    }
}
