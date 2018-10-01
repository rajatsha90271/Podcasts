//
//  DownloadsController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class DownloadsController: UITableViewController {

    // MARK: - Properties
    fileprivate let reuseIdentifier = "EpisodeCell"
    fileprivate var episodes = UserDefaults.standard.downloadedEpisodes

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes
        tableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .downloadProgress, object: nil)
        NotificationCenter.default.removeObserver(self, name: .downloadComplete, object: nil)
    }

}


// MARK: - TableView
extension DownloadsController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n\t\tLaunch episode player")
        let episode = episodes[indexPath.row]

        if episode.fileUrl != nil {
            UIApplication.mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: episodes)
        } else {
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play using stream URL instead", preferredStyle: .actionSheet)

            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                UIApplication.mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alertController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        episodes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.deleteEpisode(episode)
    }

}


// MARK: - Setup
extension DownloadsController {

    fileprivate func initialSetup() {
        setupTableView()
        setupObservers()
    }

    private func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }

    @objc private func handleDownloadProgress() {

    }

    @objc private func handleDownloadComplete() {

    }

}
