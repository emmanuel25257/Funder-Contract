// function deployFunc() {
//     console.log("Hi, This is hardhat")
// }

const { networkConfig } = require("../helper-hardhat-config")

const { networks } = require("../hardhat.config")

// module.exports.default = deployFunc


module.exports = async({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts
    const chainId = networks.config.chainId

    const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]

    const address = "0x08342C4960cFa99eb011E99016d9393141767FD4"

    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: [address],
        log: true
    })
}