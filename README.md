
# Decentralized To-Do List dApp

A blockchain-based to-do list application that allows users to manage tasks in a fully decentralized way with ownership, privacy, and immutability.

![Decentralized To-Do List](https://example.com/todo-dapp-screenshot.png)

## Features

- ✅ **Fully Decentralized** - All task data stored on the Ethereum blockchain
- 🔒 **Private** - Only you can access your tasks via your Ethereum wallet
- 🔄 **Persistent** - Tasks remain accessible across devices with no central database
- 🚀 **Feature-Rich** - Categories, priorities, deadlines, and more
- 📱 **Responsive UI** - Works on desktop and mobile devices

## Tech Stack

- **Smart Contracts**: Solidity
- **Blockchain**: Ethereum
- **Frontend**: React.js
- **Web3 Integration**: ethers.js
- **UI Framework**: Tailwind CSS
- **Development Environment**: Hardhat

## Smart Contract Features

- Create, update, complete, and delete tasks
- Add categories, priorities, and deadlines
- Filter tasks by status, category, and priority
- Track overdue and upcoming deadline tasks
- Summary statistics for your task management

## Getting Started

### Prerequisites

- Node.js v16+
- MetaMask or another Ethereum wallet
- Some test ETH for gas fees (if using testnet)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/decentralized-todo-dapp.git
   cd decentralized-todo-dapp
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file in the root directory:
   ```
   REACT_APP_INFURA_ID=your_infura_project_id
   PRIVATE_KEY=your_private_key_for_deployment
   ```

4. Compile the smart contract:
   ```bash
   npx hardhat compile
   ```

5. Deploy to local network:
   ```bash
   npx hardhat node
   npx hardhat run scripts/deploy.js --network localhost
   ```

6. Start the frontend application:
   ```bash
   npm start
   ```

7. Open your browser and navigate to `http://localhost:3000`

### Deploying to Testnet

```bash
npx hardhat run scripts/deploy.js --network goerli
```

Replace `goerli` with your preferred testnet.

## How to Use

1. **Connect Your Wallet**:
   - Click "Connect Wallet" and approve the connection in MetaMask

2. **Create a Task**:
   - Enter task details in the form
   - Set optional deadline, priority, and category
   - Click "Add Task"

3. **Manage Tasks**:
   - Mark tasks as complete by clicking the checkbox
   - Delete tasks with the trash icon
   - Update task details by clicking the edit button
   - Filter tasks using the category and status tabs

4. **View Statistics**:
   - See your task completion statistics at the bottom of the page

## Smart Contract Architecture

The decentralized to-do list is powered by the `DecentralizedTodoList.sol` smart contract. The contract includes:

- **Task Structure**: Stores all task data including content, completion status, timestamps, deadline, priority, and category
- **Mappings**: Associates task data with user addresses
- **Events**: Triggered on task creation, updates, and state changes
- **Functions**: Methods for creating, updating, filtering, and managing tasks

## Gas Optimization

The contract is optimized for gas efficiency:
- Efficient data structures to minimize storage costs
- Carefully designed functions to reduce gas usage
- Batch operations where appropriate

## Security Considerations

- Contract uses `msg.sender` for authentication, ensuring users can only access their own tasks
- Input validation prevents invalid data
- No external contract calls that could create security vulnerabilities

## Future Enhancements

- [ ] Task sharing between accounts
- [ ] Recurring tasks
- [ ] Subtasks and nested task management
- [ ] Notifications for upcoming deadlines
- [ ] Integration with calendar applications
- [ ] Mobile app version

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [OpenZeppelin](https://openzeppelin.com/) for smart contract security patterns
- [Hardhat](https://hardhat.org/) for Ethereum development environment
- [Ethers.js](https://docs.ethers.io/) for blockchain interactions
- [React](https://reactjs.org/) for the frontend framework
- [Tailwind CSS](https://tailwindcss.com/) for styling

---

Built with ❤️ by [Apeksha Gupta]

*Note: This is a proof-of-concept application. While every effort has been made to ensure security and efficiency, please use caution when deploying with real ETH.*
