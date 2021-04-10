//
//  DetailsView.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Kingfisher
import Combine

struct DetailsView : View {
    @Environment(\.injected) private var injected: DIContainer
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.detailsView)
    }
    
    @State private(set) var data: Loadable<(MoviesDetail, [Cast], [Crew])>
    let movie: Movies
    @Binding var presented: Bool
    
    @State private var page: Int = 1
    
    init(data: Loadable<(MoviesDetail, [Cast], [Crew])> = .notRequested, movie: Movies, presented: Binding<Bool>) {
        self._data = .init(initialValue: data)
        self.movie = movie
        self._presented = presented
    }
    
    var body: some View {
        NavigationView {
            self.content
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.cancellationAction) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                self.presented = false
                            }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(routingUpdate) { self.routingState = $0 }
        .onAppear {
            self.detail(id: movie.id)
        }
    }
    
    var content: some View {
        ScrollView {
            GeometryReader { reader in
                if reader.frame(in: .global).minY > -300 {
                    ImageView(url: getURL(path: movie.posterPath ?? ""))
                        .offset(y: -reader.frame(in: .global).minY)
                        .frame(width: UIScreen.main.bounds.width, height: reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY + 300 : 300)
                }
            }
            .frame(height: 300)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(movie.title ?? "")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                self.taglineState()
                    .padding(.horizontal, 20)
                
                Divider()
                    .padding(.vertical, 20)
                
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color.yellow)
                    
                    Text(movie.voteAverage?.rounded(toPlaces: 1).asString ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                
                Text(movie.overview ?? "")
                    .font(.system(size: 16))
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                self.genresState()
                    .padding(.horizontal, 20)
                
                Divider()
                    .padding(.vertical, 20)
                
                VStack {
                    NavigationLink(destination: VideosView(movie: movie)) {
                        HStack {
                            Image(systemName: "video.fill")
                                .foregroundColor(Color.red)
                            Text("Watch Trailer")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 8, height: 14)
                                .foregroundColor(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "star.lefthalf.fill")
                                .foregroundColor(Color.yellow)
                            Text("Read User Reviews")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 8, height: 14)
                                .foregroundColor(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }

                }
                .padding(.horizontal, 20)
                
                Divider()
                    .padding(.vertical, 20)
                
                Group {
                    self.crewsState()
                    
                    self.castsState()
                }
                
            }
            .padding(.vertical, 25)
            .background(Color.white)
            .cornerRadius(20)
            .offset(y: -35)
            
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
    
    func taglineState() -> some View {
        switch data {
        case let .loaded(detail):
            return Text(detail.0.tagline ?? "")
                .font(.system(size: 14))
                .italic()
                .foregroundColor(.gray)
                .padding(.top, 5)
                .toAnyView
        default: return loadingState().toAnyView
        }
    }
    
    func loadingState() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color("light_gray_color"))
            .frame(width: 100, height: 20)
            .padding(.top, 5)
            .shimmer(isActive: true)
    }
    
    func genresState() -> some View {
        switch data {
        case let .loaded(detail):
            guard let genres = detail.0.genres else { return loadingState().toAnyView }
            return loadedGenres(genres: genres).toAnyView
        default: return loadingState().toAnyView
        }
    }
    
    func loadedGenres(genres: [Genres]) -> some View {
        Text(genresAsString(genres: genres))
            .foregroundColor(Color.gray)
            .font(.system(size: 14))
            .italic()
    }
    
    func crewsState() -> some View {
        switch data {
        case .isLoading:
            return DetailsView.CrewLoading().toAnyView
        case let .loaded(detail):
            return DetailsView.CrewList(crews: detail.2.filter({ $0.job == "Director" || $0.job == "Screenplay" || $0.job == "Story" }).sorted { $0.job ?? "" < $1.job ?? ""}).toAnyView
        default:
            return EmptyView().toAnyView
        }
    }
    
    func castsState() -> some View {
        switch data {
        case .isLoading:
            return DetailsView.CastLoading().toAnyView
        case let .loaded(detail):
            return DetailsView.CastList(casts: detail.1).toAnyView
        default:
            return EmptyView().toAnyView
        }
    }
}

// MARK: Helpers
private extension DetailsView {
    func getURL(path: String) -> URL {
        return URL(string: "https://www.themoviedb.org/t/p/w500\(path)")!
    }
    
    func genresAsString(genres: [Genres]) -> String {
        var genre = ""
        genres.forEach { (g) in
            genre += "#\(g.name ?? "") "
        }
        return genre
    }
}

// MARK: - Side Effects
private extension DetailsView {
    func detail(id: Int?) {
        guard let id = id else { return }
        injected.interactors.moviesInteractor.detail(data: $data, id: id)
    }
}

// MARK: - Routing
extension DetailsView {
    struct Routing: Equatable {
        
    }
}

// MARK: - State Updates
private extension DetailsView {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.detailsView)
    }
}
