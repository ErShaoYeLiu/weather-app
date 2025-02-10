//
//  ViewController.swift
//  WeatherApp
//
//  Created by codeL on 2025/2/9.
//

import UIKit
import DGCharts

class ViewController: UIViewController, UITableViewDataSource, ChartViewDelegate {
    private let lineChartView = LineChartView()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style:.large)
    private let errorLabel = UILabel()
    private var weatherData: WeatherData?
    private var retryCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        fetchWeather()
    }

    private func setupUI() {
        view.backgroundColor = .white

        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.delegate = self
        lineChartView.chartDescription.enabled = false
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = true
        view.addSubview(lineChartView)
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lineChartView.heightAnchor.constraint(equalToConstant: 200)
        ])

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        errorLabel.isHidden = true

        lineChartView.delegate = self
        lineChartView.scaleXEnabled = true
        lineChartView.scaleYEnabled = true
        lineChartView.pinchZoomEnabled = true
    }

    private func fetchWeather() {
        WeatherService.fetchWeatherData { [weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                case.success(let data):
                    self?.weatherData = data
                    print("数据请求")
                    print(data)
                    self?.updateChart()
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.reloadData()
                    self?.retryCount = 0
                case.failure(let error):
                    if self!.retryCount < 3 {
                        self?.retryCount += 1
                        self?.fetchWeather()
                    } else {
                        self?.errorLabel.text = "Error: \(error.localizedDescription)"
                        self?.errorLabel.isHidden = false
                    }
                }
            }
        }
    }

    private func updateChart() {
        guard let weatherData = weatherData else { return }
        var entries = [ChartDataEntry]()
        for (index, temperature) in weatherData.hourly.temperature_2m.enumerated() {
            let entry = ChartDataEntry(x: Double(index), y: temperature)
            entries.append(entry)
        }
        let dataSet = LineChartDataSet(entries: entries, label: "Temperature (°C)")
        dataSet.colors = [.blue]
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
        lineChartView.chartDescription.text = "温度"
        lineChartView.notifyDataSetChanged()
    }
    
    func formatterDate(date:String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let date = inputFormatter.date(from: date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let outputDateString = outputFormatter.string(from: date)
            print(outputDateString)
            return outputDateString
        } else {
            print("日期字符串格式不正确，无法解析。")
            return "";
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.hourly.time.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        if let weatherData = weatherData {
//            let time = weatherData.hourly.time[indexPath.row]
//            let temperature = weatherData.hourly.temperature_2m[indexPath.row]
//            cell.textLabel?.text = "\(formatterDate(date: time)) "
//            cell.detailTextLabel?.text = "\(temperature)°C"
//            
//        }
//        return cell
        //custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
                if let weatherData = weatherData {
                    let time = weatherData.hourly.time[indexPath.row]
                    let temperature = weatherData.hourly.temperature_2m[indexPath.row]
                    cell.configure(leftText: "\(formatterDate(date: time))", rightText: " \(temperature)°C")
        
                }
                return cell
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let weatherData = weatherData {
            let index = Int(entry.x)
            let time = weatherData.hourly.time[index]
            let temperature = weatherData.hourly.temperature_2m[index]
            let alert = UIAlertController(title: "Temperature Details", message: "\(formatterDate(date: time)): \(temperature) °C", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
